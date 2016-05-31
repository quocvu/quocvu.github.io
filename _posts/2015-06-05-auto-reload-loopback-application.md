---
layout: post
title: Auto Reload Loopback Application
excerpt: "How to auto reload a Loopback application after updating your code "
modified: 2015-06-05
tags: [StrongLoop, LoopBack, auto reload]
comments: true
image:
  feature: lighthouse.jpg
  credit: 
  creditlink: 
---

This post shows you how auto reload a Loopback application after making changes to your code.  You no longer have to stop the server and restart it.

For that we will `grunt` with `nodemon` module. So let's install them

{% highlight sh %}
$ npm install --save grunt grunt-cli grunt-nodemon
{% endhighlight %}

Now let's configure grunt to perform the auto-reload.  Place this `gruntfile.js` file in the root your Loopback application.

{% highlight javascript linenos %}
'use strict';

module.exports = function(grunt) {
  // Project Configuration
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    nodemon: {
      dev: {
        script: 'server/server.js',
        options: {
          args: ['dev'],
          nodeArgs: ['--debug'],
          callback: function (nodemon) {
            nodemon.on('log', function (event) {
              console.log(event.colour);
            });
          },
          env: {
            PORT: '3000'
          },
          cwd: __dirname,
          ignore: ['node_modules/**'],
          ext: 'js,coffee',
          watch: ['server', 'common'],
          delay: 1000,
          legacyWatch: true
        }
      }
    },
    
    env: {
      dev: {
        NODE_ENV: 'dev'
      }
    }
  });

  // Making grunt default to force in order not to break the project.
  grunt.option('force', true);

  // Default task(s).
  grunt.registerTask('default', ['nodemon']);

  grunt.loadNpmTasks('grunt-nodemon');
};
{% endhighlight %}

Chances are you already use `grunt` to perform other tasks, in this case just add the `nodemon`
section (line 8 to 30) and the loading instruction (line 45).

To start your Loopback server, go to the root of you application and just type the command `grunt`