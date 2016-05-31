---
layout: post
title: Adding a AngularJS filter to a MEAN JS app
excerpt: "This post shows how to add a 3rd party AngularJS filter and use it in your views"
modified: 2015-02-10
tags: [angular js, filter, third party, views]
comments: true
image:
  feature: lighthouse.jpg
  credit: 
  creditlink: 
---

This post shows how to add a 3rd party AngularJS filter and use it in your views. Let's use the `angular-truncate` filter as an example.  It can be found at <https://github.com/sparkalow/angular-truncate>.


First, import the filter into the app

{% highlight sh %}
$ bower i --save angular-truncate
{% endhighlight %}

You should see a folder `public/lib/angular-truncate`

Second, to tell MEAN.JS to load this filter in your template, edit `config/env/all.js` and add a new element to the `assets.lib.js` array with `public/lib/angular-truncate/src/truncate.js` (line 28).

{% highlight javascript linenos %}
'use strict';

module.exports = {
  app: {
    title: 'TestApp',
    description: 'Full-Stack JavaScript with MongoDB, Express, AngularJS, and Node.js',
    keywords: 'MongoDB, Express, AngularJS, Node.js'
  },
  port: process.env.PORT || 3000,
  templateEngine: 'swig',
  sessionSecret: 'MEAN',
  sessionCollection: 'sessions',
  assets: {
    lib: {
      css: [
        'public/lib/bootstrap/dist/css/bootstrap.css',
        'public/lib/bootstrap/dist/css/bootstrap-theme.css',
      ],
      js: [
        'public/lib/angular/angular.js',
        'public/lib/angular-resource/angular-resource.js', 
        'public/lib/angular-cookies/angular-cookies.js', 
        'public/lib/angular-animate/angular-animate.js', 
        'public/lib/angular-touch/angular-touch.js', 
        'public/lib/angular-sanitize/angular-sanitize.js', 
        'public/lib/angular-ui-router/release/angular-ui-router.js',
        'public/lib/angular-ui-utils/ui-utils.js',
        'public/lib/angular-truncate/src/truncate.js',
        'public/lib/angular-bootstrap/ui-bootstrap-tpls.js'
      ]
    },
    css: [
      'public/modules/**/css/*.css'
    ],
    js: [
      'public/config.js',
      'public/application.js',
      'public/modules/*/*.js',
      'public/modules/*/*[!tests]*/*.js'
    ],
    tests: [
      'public/lib/angular-mocks/angular-mocks.js',
      'public/modules/*/tests/*.js'
    ]
  }
};
{% endhighlight %}

Third, to inject it into your app, edit the `public/config.js` file and add a new element to the end of the array `applicationModuleVendorDependencies` with the module name `truncate` (line 7).

{% highlight javascript linenos %}
'use strict';

// Init the application configuration module for AngularJS application
var ApplicationConfiguration = (function() {
  // Init module configuration options
  var applicationModuleName = 'test';
  var applicationModuleVendorDependencies = ['ngResource', 'ngCookies',  'ngAnimate',  'ngTouch',  'ngSanitize',  'ui.router', 'ui.bootstrap', 'ui.utils', 'truncate'];

  // Add a new vertical module
  var registerModule = function(moduleName, dependencies) {
    // Create angular module
    angular.module(moduleName, dependencies || []);

    // Add the module to the AngularJS configuration file
    angular.module(applicationModuleName).requires.push(moduleName);
  };

  return {
    applicationModuleName: applicationModuleName,
    applicationModuleVendorDependencies: applicationModuleVendorDependencies,
    registerModule: registerModule
  };
})();
{% endhighlight %}

Lastly, you may now use the filter in your view to truncate the description to 200 characters long as 

{% highlight javascript %}
{{ "{{ description | characters:200 " }}}}
{% endhighlight %}
