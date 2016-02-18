---
layout: post
title: Setup Test Coverage for your Node App in a Breeze
excerpt: "How to setup your test coverage in the cloud"
modified: 2016-01-23
tags: [nodejs, javascript, ci, continuous integration, test, coverage, travisci, houndci, coveralls, istanbul]
comments: true
image:
  feature: lighthouse.jpg
  credit:
  creditlink:
---

It is always a good things to write units tests against our code.  Once we have some unit tests written,
the next question is do our tests have enough code coverage.  This post shows you how to setup up your CI to run
unit tests and report them using cloud based tools. More specifically, we use [TravisCI](https://travis-ci.org)
to perform builds and we show the test coverage on [Coveralls.io](https://coveralls.io).

# Source App

Let say we have a Node app containing a file `src/age.js` with the following code:

{% highlight javascript linenos %}
'use strict';

module.exports = {
  older: function (a, b) {
    if (a.age > b.age) {
      return a.name + ' is older than ' + b.name;
    } else if (b.age > a.age) {
      return b.name + ' is older than ' + a.name;
    } else {
      return a.name + ' and ' + b.name + ' have the same age';
    }
  }
}
{% endhighlight %}

# Unit Tests

Now, we add unit tests for the code above.  We put the tests in 'test/age.js' as:

{% highlight javascript linenos %}
var should = require('should'),
  age = require('../src/age.js');

describe('My test suite', function () {
  var ben = { name: 'Ben', age: 31 },
    frank = { name: 'Frank', age: 27 },
    john = { name: 'John', age: 27 };

  it('should assess who is older', function () {
    age.older(ben, frank).should.be.equal('Ben is older than Frank');
    age.older(frank, ben).should.be.equal('Ben is older than Frank');
    age.older(john, frank).should.be.equal('John and Frank have the same age');
  })
});
{% endhighlight %}

To use [Mocha](https://mochajs.org/) to run our tests, we add it to our app:

    $ npm install --save-dev mocha

Then we create a new npm command to run our tests by adding this to our `package.json`

{% highlight json linenos %}
"scripts": {
  "test": "NODE_ENV=test mocha"
}
{% endhighlight %}


And we execute all files under the `test` directory.  We should see something like this:

{% highlight bash linenos %}
$ npm test

> node_test_sample@1.0.0 test /node_test_sample
> NODE_ENV=test mocha



  My test suite
    ✓ should assess who is older


  1 passing (47ms)
{% endhighlight %}

# Automated Builds with TravisCI

We use [TravisCI](https://travis-ci.org) to perform automated builds upon check ins.
It runs our unit tests and let us know if there are problems.  Let's set it up.

* Sign up for account with TravisCI by using our GitHub ID. That links the 2 accounts together.
* Go to [our TravisCI account](https://travis-ci.org/profile) and we should see a list of GitHub repos.
If that list is empty, comeback in 10 minutes to allow it to sync up.
* Add a `.travis.yml` file at the root of the Node project (where `package.json` is located) with the following:

{% highlight yaml linenos %}
language: node_js
node_js:
  - "4.2"
  - "4.1"
  - "4.0"
{% endhighlight %}

* Push this change to GitHub and TravisCI will fire a new build.  By default it runs `npm test`.
* Go to our [TravisCI dashboard](https://travis-ci.org) to see the status of the new build.
* Click on the badge, select `Markdown`, copy the little snippet, and paste it at the top of
the `README.md` file. The status of the build is now shown directly on our GitHub repo main page.

![TravisCI Badge]({{ site.url }}/assets/images/quocvu_node_test_sample_travisci_badge.png)

At this point, our Node app is getting built automatically upon each check in and we get to know if our tests passed
or failed from our Github repo page or TravisCI dashboard.

# Code Coverage

It's cool to know our tests passed, but it won't be any good if they cover only 1% of our code.  Thus we also need
to know how much our tests cover.

## Calculate Code Coverage

We use [Istanbul](https://gotwarlost.github.io/istanbul) to calculate code coverage. We add it to our project

    $npm install --save-dev istanbul

We create a npm command to run it by putting this in `package.json`

{% highlight json linenos %}
"scripts": {
  "test": "NODE_ENV=test mocha",
  "cover": "NODE_ENV=test istanbul cover _mocha"
}
{% endhighlight %}

Note we use `_mocha` (underscore mocha) so that it doesn't run in a child process.  Now our test run looks like this:

{% highlight bash linenos %}
$ npm run cover

> node_test_sample@1.0.0 cover /node_test_sample
> NODE_ENV=test istanbul cover _mocha



  My test suite
    ✓ should assess who is older


  1 passing (20ms)

=============================================================================
Writing coverage object [/node_test_sample/coverage/coverage.json]
Writing coverage reports at [/node_test_sample/coverage]
=============================================================================

=============================== Coverage summary ===============================
Statements   : 100% ( 6/6 )
Branches     : 100% ( 4/4 )
Functions    : 100% ( 1/1 )
Lines        : 100% ( 6/6 )
================================================================================
{% endhighlight %}

As you can see, the code coverage results are being stored in the `./coverage` directory. Add this directory to
`.gitignore` to avoid having them in our repo.


## Publishing Code Coverage

We want publish our code coverage results (in the ./coverage directory) to [Coveralls](http://coveralls.io/).
Not only it displays a nice code coverage reports, it can also send notifications when the coverage drops below
a certain point or when it drops significantly.

Let's set it up.

* Sign up for an account at [Coveralls](http://coveralls.io/) using your GitHub account. The 2 accounts will be linked.
* Click on the `Repo` menu on the left navigation
* Click on `Add Repo` button on the top right corner to add this GitHub repo
* Add these 2 modules to our project to upload coverage results to Coveralls

    $ npm install --save-dev coveralls mocha-lcov-reporter

* Create a npm command to run the upload.  Put this in `package.json`

{% highlight json linenos %}
"scripts": {
  "test": "NODE_ENV=test mocha",
  "cover": "NODE_ENV=test istanbul cover _mocha",
  "coveralls": "npm run cover -- --report lcovonly && cat ./coverage/lcov.info | coveralls"
}
{% endhighlight %}

* Make TravisCI run our code coverage by adding this to `.travis.yml`

{% highlight yaml linenos %}
after_success:
  - npm run coveralls
{% endhighlight %}

* Push this change to GitHub, it will fire a Travis build, which now will run code coverage, and upload to Coveralls.
* Go to [Coveralls](http://coveralls.io/), that's our dashboard
* Click on this repo, then click on the `Badge Urls` button on the top right corner, copy the snippet for `Markdown`,
and paste it at the top of our `README.md` file. Now we can see the coverage percentage directly from GitHub.

![Coveralls Badge]({{ site.url }}/assets/images/quocvu_node_test_sample_coveralls_badge.png)


# Voila!

That's all folks.  Let's look at our awesome repo.  You can find it at <https://github.com/quocvu/node_test_sample>.
Click on the 2 badges to see more details in TravisCI and Coveralls.

![GitHub Repo]({{ site.url }}/assets/images/quocvu_node_test_sample_repo.png)

![TravisCI Dashoard]({{ site.url }}/assets/images/quocvu_node_test_sample_travisci_dashboard.png)

![Coveralls Dashoard]({{ site.url }}/assets/images/quocvu_node_test_sample_coveralls_dashboard.png)

