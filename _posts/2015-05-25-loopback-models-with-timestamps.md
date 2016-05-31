---
layout: post
title: Loopback Models With Timestamps
excerpt: "How to add timestamps to all your Loopback models"
modified: 2015-05-25
tags: [StrongLoop, LoopBack, model, timestamps]
comments: true
image:
  feature: lighthouse.jpg
  credit: 
  creditlink: 
---

This post shows you how add timestamps such as created_at and updated_at to all your models in Loopback.

## A Base Model

First define a base model that all models will inherit from.  You can use the model generator, or put add these 2 files in your project/

**common/models/base-model.json**

{% highlight html linenos %}
{
  "name": "BaseModel",
  "base": "PersistedModel",
  "idInjection": true,
  "options": {
    "validateUpsert": true
  },
  "properties": {
    "createdAt": {
      "type": "date",
      "defaultFn": "now",
      "required": true
    },
    "updatedAt": {
      "type": "date",
      "defaultFn": "now",
      "required": true
    },
    "deletedAt": {
      "type": "date"
    }
  },
  "validations": [],
  "relations": {},
  "acls": [],
  "methods": []
}
{% endhighlight %}

We simply define 3 date fields createdAt, updatedAt, and deletedAt (if you wish to implement a soft delete).

**common/models/base-model.js**

{% highlight html linenos %}
module.exports = function(BaseModel) {

  BaseModel.beforeCreate = function (next, model) {
    model.createdAt = Date.now();
    next();
  };

  BaseModel.beforeUpdate = function (next, model) {
    model.updatedAt = Date.now();
    next();
  };
};
{% endhighlight %}

We define the behavior before an instance of the model is created and updated.

The everytime, we add a new model, we use BaseModel as the base model. It's that simple.

**Note:** This method is only supported if you use the in memory database, MySQL, or MongoDB connectors.