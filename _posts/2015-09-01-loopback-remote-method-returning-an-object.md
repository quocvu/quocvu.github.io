---
layout: post
title: Loopback Remote Method Returning an Object
excerpt: "How to return a object data type in a Loopback remote method"
modified: 2015-06-05
tags: [StrongLoop, LoopBack, auto reload]
comments: true
image:
  feature: lighthouse.jpg
---

I just want to expand on documentation of [remote methods](https://docs.strongloop.com/display/public/LB/Remote+methods) 
and hope I can save you some time.  

The documentation shows how to return a string and we can easily see how it would work for any primitive data types. 
The handler (i.e. Person.great function) returns a string, the REST API, wrap it with a JSON object and returns 
`{ "greetings": "Greetings... John!" }`.

Now let say we have a method returning the address where this person lives. The handler would return an object (e.g. a model).

{% highlight javascript linenos %}
module.exports = function(Person) {
     
  Person.address = function(personId, cb) {
    // address is an object that would look like 
    // { street: '22 Main St', city: 'San Jose', zipcode: 95148 }
    var address = ...; // do something to lookup the address based on personId
    cb(null, address);
  }
   
  Person.remoteMethod('address', {
    http: { path: '/:personId/address', verb: 'get' },
    accepts: { arg: 'personId', type: 'number', required: true },
    returns: { type: 'object', root: true }
  });
};
{% endhighlight %}

The thing I want to point out here is the property `root: true` on line 13. 
Without it it would return a JSON like this 

```
{
  "undefined": {
    "street": "22 Main St",
    "city": "San Jose",
    "zipcode": "95148"
  }
}
```

I found out about by enabling debugging by starting the app this way: 

    $ DEBUG=loopback:explorer:routeHelpers node .