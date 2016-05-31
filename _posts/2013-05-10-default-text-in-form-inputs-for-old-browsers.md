---
layout: post
title: Default text in form inputs for old browsers
excerpt: "A cool trick To support old browser without `placeholder` attribute"
modified: 2013-05-31
tags: [html, javascript, jquery, form, default, old-browser, trick, tip]
comments: true
image:
  feature: lighthouse.jpg
  credit: 
  creditlink: 
---

To support old browser without `placeholder` attribute, use this cool trick to set default text in input forms. 

If the input box is empty it shows the default text and clears it when the cursor is focused on input. Then it puts the default text back once the cursors leaves without any character entered. This javascript does that

{% highlight javascript %}
$(document).ready(function() {
    /* Default Text */
    $('.default-text').live('focus', removeDefaultText);
    $('.default-text').live('blur', addDefaultText);
    $('.default-text').blur();
});
 
var addDefaultText = function () {
    if ($(this).val() == '') {
        $(this).addClass('enabled').val($(this).attr('title'));
    }
    return false;
};
 
var removeDefaultText = function () {
    if ($(this).attr('title') == $(this).val()) {
        $(this).removeClass('enabled').val('');
    }
    return false;
};
{% endhighlight %}

In your form input be sure to add the attributes `class="default-text"` and `title="your default text here"`