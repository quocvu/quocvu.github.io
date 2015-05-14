---
layout: post
title: Customize Bootstrap within MEAN.JS
excerpt: "How to avoid having layers of CSS files and easier customization of Bootstrap"
modified: 2014-09-24
tags: [less, bootstrap, meanjs, nodejs, angularjs]
comments: true
image:
  feature: lighthouse.jpg
  credit: 
  creditlink: 
---

Currently, MEAN.JS ships with Bootstrap but does not support extending it with LESS. 
To add additional styles, we need to add CSS files. 
To customize the default theme, we need to overwrite exiting styles with a new CSS. 
This layered approach is impractical for several reasons. 
First, we need write CSS instead of LESS. Second, we don't get access to all the variables and mixins provided by Bootstrap.

I would much rather generate a single CSS file combining Bootstrap, my customizations, and additional styles together. 
This file is placed in public/application.min.css. 
Let's see how we add LESS compilation and remove the existing auto inclusion of CSS files scattered in various AngularJS modules.


# Remove CSS

Edit `config/env/all.js`: 

* Remove from `assets.lib.css` array`public/lib/bootstrap/dist/css/bootstrap.css` and `public/lib/bootstrap/dist/css/bootstrap-theme.css`. Make sure to leave an empty array (don't remove the css array) as shown on line 26.
* Remove from `assets.css` the first element `public/modules/**/css/*.css`. We don't write CSS but LESS. 
* Add `public/application.min.css` to this array (line 29). It will be auto included by `app/views/templates/layout.server.view.html`

{% highlight javascript linenos %}
'use strict';

module.exports = {
  app: {
    title: 'my first MEAN.JS app',
    description: 'Try out MEAN.JS',
    keywords: 'nodejs, meanjs, trial'
  },
  port: process.env.PORT || 3000,
  templateEngine: 'swig',
  sessionSecret: 'MEAN',
  sessionCollection: 'sessions',
  assets: {
    lib: {
      js: [
        'public/lib/angular/angular.js',
        'public/lib/angular-resource/angular-resource.js', 
        'public/lib/angular-cookies/angular-cookies.js', 
        'public/lib/angular-animate/angular-animate.js', 
        'public/lib/angular-touch/angular-touch.js', 
        'public/lib/angular-sanitize/angular-sanitize.js', 
        'public/lib/angular-ui-router/release/angular-ui-router.js',
        'public/lib/angular-ui-utils/ui-utils.js',
        'public/lib/angular-bootstrap/ui-bootstrap-tpls.js'
      ],
      css: [],
    },
    css: [
      'public/application.min.css',
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

Edit `config/env/production.js` and remove `assets.lib.css` and `assets.css` entries.  

# Combine LESS Files Into One

* Copy the file `public/lib/bootstrap/less/bootstrap.less` to `public/less/application.less` and fix the import path of less files.
* Add a file `public/less/variables.less` to overwrite Bootstrap variables and add any new variables. Import it into `public/less/application.less` by inserting it right after the import of bootstrap variables (line 4).
* Add a file `public/less/mixins.less` to overwrite Bootstrap mixins and define your own mixins.  Import it into `public/less/application.less` by inserting it right after the import of bootstrap mixins (line 8).
* Include any other LESS files you need to create. Files defining styles for the entire application would go in `public/less` (line 58). Files with style for specific modules go in their respective less folders `public/modules/xyz/less` (lines 59 and 60).

The `public/less/application.less` should look like this:

{% highlight javascript linenos %}
// Core variables and mixins
@import "../lib/bootstrap/less/variables.less";
// -- Overwrite bootstrap and additional variables
@import "variables.less";

@import "../lib/bootstrap/less/mixins.less";
// -- Overwrite bootstrap and additional mixins
@import "mixins.less";

// Reset and dependencies
@import "../lib/bootstrap/less/normalize.less";
@import "../lib/bootstrap/less/print.less";
@import "../lib/bootstrap/less/glyphicons.less";

// Core CSS
@import "../lib/bootstrap/less/scaffolding.less";
@import "../lib/bootstrap/less/type.less";
@import "../lib/bootstrap/less/code.less";
@import "../lib/bootstrap/less/grid.less";
@import "../lib/bootstrap/less/tables.less";
@import "../lib/bootstrap/less/forms.less";
@import "../lib/bootstrap/less/buttons.less";

// Components
@import "../lib/bootstrap/less/component-animations.less";
@import "../lib/bootstrap/less/dropdowns.less";
@import "../lib/bootstrap/less/button-groups.less";
@import "../lib/bootstrap/less/input-groups.less";
@import "../lib/bootstrap/less/navs.less";
@import "../lib/bootstrap/less/navbar.less";
@import "../lib/bootstrap/less/breadcrumbs.less";
@import "../lib/bootstrap/less/pagination.less";
@import "../lib/bootstrap/less/pager.less";
@import "../lib/bootstrap/less/labels.less";
@import "../lib/bootstrap/less/badges.less";
@import "../lib/bootstrap/less/jumbotron.less";
@import "../lib/bootstrap/less/thumbnails.less";
@import "../lib/bootstrap/less/alerts.less";
@import "../lib/bootstrap/less/progress-bars.less";
@import "../lib/bootstrap/less/media.less";
@import "../lib/bootstrap/less/list-group.less";
@import "../lib/bootstrap/less/panels.less";
@import "../lib/bootstrap/less/responsive-embed.less";
@import "../lib/bootstrap/less/wells.less";
@import "../lib/bootstrap/less/close.less";

// Components w/ JavaScript
@import "../lib/bootstrap/less/modals.less";
@import "../lib/bootstrap/less/tooltip.less";
@import "../lib/bootstrap/less/popovers.less";
@import "../lib/bootstrap/less/carousel.less";

// Utility classes
@import "../lib/bootstrap/less/utilities.less";
@import "../lib/bootstrap/less/responsive-utilities.less";

// these are your LESS files
@import "style.less"
@import "../modules/one/less/style.less"
@import "../modules/two/less/style.less"
{% endhighlight %}

# Add LESS Support

Install the grunt task to compile LESS files

{% highlight sh %}
% npm install grunt-contrib-less --save
{% endhighlight %}

Tell grunt to compile our LESS file by adding this block into `gruntfile.js` in the `grunt.initConfig` options

{% highlight javascript linenos %}
less: {
  production: {
    options: {
      paths: ['public/less'],
      cleancss: true,
      compress: true
    },
    files: {
      'public/application.min.css': 'public/less/application.less'
    }
  },
  development: { 
    options: { 
      sourceMap: true, 
      ieCompat:true, 
      dumpLineNumbers:true 
    },
    files: {
      'public/application.min.css': 'public/less/application.less'
    }
  }
},
{% endhighlight %}

Remove the `uglify` and `cssmin` sections, they are no longer needed. Less do this while compiling the combined file.

In the `build` task remove `cssmin` and `uglify` and add `less`

{% highlight javascript %}
grunt.registerTask('build', ['lint', 'loadConfig', 'ngmin', 'less']);
{% endhighlight  %}

Change `ngAnnotate.production.files` to `'public/application.js': '<%= applicationJavaScriptFiles %>'`

Then load the less task installed earlier

{% highlight javascript %}
 grunt.loadNpmTasks('grunt-contrib-less');
{% endhighlight  %}

Now, go to your shell and compile LESS by running `grunt build` or `grunt less`

# Auto reload

Once you built `application.min.css`, you can have the browser auto reload it by editing `gruntfile.js` and change the `watchFiles` options to 

{% highlight javascript %}
clientCSS: ['public/application.min.css', 'public/modules/**/*.css'],
{% endhighlight  %}
