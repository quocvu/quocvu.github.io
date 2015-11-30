---
layout: post
title: Stubbing required NodeJS modules with Sinon
excerpt: How to stub methods from imported modules to control their behaviors
modified: 2015-11-29
tags: [nodejs, node, js, unit, test, mock, stub, spy, sinon, require, module, control, behavior]
comments: true
image:
  feature: lighthouse.jpg
  credit: 
  creditlink: 
---

In this post, I will show how to stub functions from imported modules so that to isolate 
the code to be unit tested.

Let's first write a function to test. This function simply 
[retrieves a list of organizations](https://developer.github.com/v3/orgs/#list-all-organizations) 
from GitHub using its REST API.

{% highlight javascript linenos %}
var request = require('request');

module.exports = {
  getOrgs: function() {
    var options = {
      uri: 'https://api.github.com/organizations',
      headers: {
        'User-Agent': 'My-test-app'
      }
    }

    request.get(options, function(err, response, body) {
      if (err) {
        console.error('An error occured');

        // handle this error
      } else {
        if (response.statusCode === 200) {
          console.log('Received', body.length, 'organizations');

          // do something with the orgs in the body
        } else {
          console.warn('Cannot retrieve organizations', response.statusCode);

          // handle this corner case
        }
      }
    }); 
  }  
}
{% endhighlight %}

Through this example, we show how to stub a method (get) from an imported module (request) 
and how to verify the different parts of the callback function being executed.

Here we rely on the `request` module (imported by line 1) to make an HTTPS request to 
GitHub. But, when running unit tests, we cannot let it makes round trips to GitHub and hoping it
would always return the results we need. Instead we need to control the results of the 
`request.get()` method so that we can achieve the desired test coverage of our code from line 
13 to 27. For that we need to stub this method and we will do that with the help of the 
[SinonJS](http://sinonjs.org) module.

Let's see what our unit tests look like. We assume the code above is in a file called `app.js` 
located in the same directory as this test code.

{% highlight javascript linenos %}
var 
  mocha = require('mocha'),
  should = require('should'),
  sinon = require('sinon');
  request = require('request'),
  app = require('./app');

describe('sinon stub tutorial', function() {
  it('should get some organizations returned', function(doneCallback) {
    sinon.spy(console, 'log');      
    sinon
      .stub(request, 'get')
      .yields(null, { statusCode: 200 }, [{ name: 'org-one' }, { name: 'org-two'}]);

    app.getOrgs();

    request.get.calledOnce.should.be.true();
    console.log.calledOnce.should.be.true();
    console.log.calledWith('Received', 2, 'organizations').should.be.true();

    request.get.restore();    
    console.log.restore();
    doneCallback();
  });

  it('should have a bad status code', function(doneCallback) {
    sinon.spy(console, 'warn');      
    sinon
      .stub(request, 'get')
      .yields(null, { statusCode: 403 }, null);

    app.getOrgs();

    request.get.calledOnce.should.be.true();
    console.warn.calledOnce.should.be.true();

    request.get.restore();    
    console.warn.restore();
    doneCallback();
  });

  it('should have an error', function(doneCallback) {
    sinon.spy(console, 'error');      
    sinon
      .stub(request, 'get')
      .yields('something really bad happened', null, null);

    app.getOrgs();

    request.get.calledOnce.should.be.true();
    console.error.calledOnce.should.be.true();

    request.get.restore();    
    console.error.restore();
    doneCallback();
  });
});
{% endhighlight %}

**Stubs**

Line 5 imports the `request` module again althought it was already imported in `app.js` file.  
This is necessary to stub its functions later. In Node.js `require(..)` loads modules once into 
a cache. Thus we load it here first, stub the functions we need, and then `app.js` will just use it. 
Thus the order of the imported modules at lines 5 and 6 is very important.

Now that the `request` object is accessible in our tests, we can replace its `get()` function by a 
[stub](http://sinonjs.org/docs/#stubs). Test stubs are functions with pre-programmed behavior allowing
us to control the code paths to test. We stub `request.get()` at lines 12, 29, and 45 with the function
`sinon.stub(request, 'get')`.  That creates a stub.

To control the results of the stub, we use its `.yields()` method at lines 13, 30, and 46. The 3 parameters
correspond to the values being passed into the anonymous function at line 12 of `app.js`.  We passed 
different set of values to cover the different code paths of this anonymous function.

And that's how simple it is to stub functions of imported modules.

**Spies**

To verify the various parts of the anonymous function are being executed properly, we use 
[spies](http://sinonjs.org/docs/#spies).  A test spy is a function that records arguments, return value, 
the value of this and exception thrown (if any) for all its calls. We create a spy using `sinon.spy()` 
method as shown at lines 10, 27, and 43. We can check the spies are being called as expected at lines 
18, 19, 35, and 51.

Note stubs are also spies, thus we can also check they are being executed as shown at lines 17, 34, and 50.
