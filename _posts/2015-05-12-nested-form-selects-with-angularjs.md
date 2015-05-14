---
layout: post
title: Nested Form Selects With AngularJS
excerpt: "How implement a for with nested selects in Angular JS"
modified: 2015-05-13
tags: [Angular JS, form, select, nested, multi-level]
comments: true
image:
  feature: lighthouse.jpg
  credit: 
  creditlink: 
---

This post shows you how easy it is to create a form with nested select dropdowns.
In this example, we render a form showing cities of the selected country from a given continent.

## A Small Dataset

### The HTML 

{% highlight html linenos %}
<!DOCTYPE html>
<html ng-app="SelectExampleApp">

  <head>
    <link rel="stylesheet" href="style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.27/angular.min.js"></script>
    <script src="script.js"></script>
  </head>

  <body>
    <h1>Nested For Select Example</h1>
    
    <div ng-controller="SelectController as ctrl">
      Continent:
      <select id="continents" ng-model="ctrl.selectedContinent" ng-options="i.name for i in ctrl.continents">
        <option value=''>Select</option>
      </select>
      
      <br/>
      
      Country:
      <select id="countries" ng-model="ctrl.selectedCountry" ng-options="i.name for i in ctrl.selectedContinent.countries">
        <option value=''>Select</option>
      </select>
      
      <br/>
      
      City:
      <select id="cities" ng-model="ctrl.selectedCity" ng-options="i for i in ctrl.selectedCountry.cities">
        <option value=''>Select</option>
      </select>

      <hr/>
      <h3>selected values:</h3>
      
      <p>Continent: {{ ctrl.selectedContinent.name }} ({{ ctrl.selectedContinent.id }})</p>
      <p>Country: {{ ctrl.selectedCountry.name }}</p>
      <p>City: {{ ctrl.selectedCity }}</p>
      
    </div>
  </body>

</html>
{% endhighlight %}

On line 15, the `ng-options` attribute iterates over the list of continents stored in `ctrl.continents` and dynamically creates the <option> tags for the select control.
The continent selected by the user is then stored in the variable `ctrl.selectedContinent` as indicated by the `ng-model` attribute.

Because AngularJS has a kick-ass 2-way binding, the 2nd select control on line 22 is automatically updated with the list of contries from the selected continent above.
The variable `ctrl.selectedContinent.countries` always contains the countries from the current selected continent. 

Similarly the selected country is stored in the variable `ctrl.selectedCountry` which is used on line 29 to update the list of cities.

### The Javascript

{% highlight javascript linenos %}
// script.js

angular.module('SelectExampleApp', [])
  .controller('SelectController', function() {
    Javascript
    // selections are stored in these 3 variables
    this.selectedContinent;
    this.selectedCountry;
    this.selectedCity;
    
    // this is our dataset
    this.continents = [
      {
        'id': 'AM',
        'name': 'Americas',
        'countries': [
          {
            'name': 'United States',
            'cities': ['New York', 'San Francisco', 'Los Angeles', 'Chicago']
          },
          { 
            'name': 'Canada',
            'cities': ['Montreal', 'Toronto', 'Vancouver']
          }
        ]
      },
      {
        'id': 'EU',
        'name': 'Europe',
        'countries': [
          {
            'name': 'France',        ]

            'cities': ['Paris', 'Lyon', 'Marseilles']
          },
          {
            'name': 'Italy',
            'cities': ['Rome', 'Florence', 'Milan', 'Venice']
          }
        ]
      },
      {
        'id': 'AS',
        'name': 'Asia',
        'countries': [
          {
            'name': 'Japan',
            'cities': ['Tokyo', 'Osaka', 'Kobe']
          },
          {
            'name': 'China',
            'cities': ['Beijing', 'Shanghai', 'Hong Kong']
          }
        ]
      }
    ];
  });
{% endhighlight %}

There is nothing really special in the JS file. It just has the variables to hold the selected options and the dataset.

You can see this in action on [Plunker](http://plnkr.co/FPC636)

## A Large Dataset

In the example above, the dataset was inlined within the front end (AngularJS) controller. 
That is okay as long as the dataset is fairly small in size and quite static (e.g. its content doesn not change often).

Let's see how we can deal with a large or dynamic dataset that we can retrieve with some REST API calls.

### The HTML 

{% highlight html linenos %}
<!DOCTYPE html>
<html ng-app="SelectExampleApp">

  <head>
    <link rel="stylesheet" href="style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.27/angular.min.js"></script>
    <script src="script.js"></script>
  </head>

  <body>
    <h1>Nested For Select Example</h1>
    
    <div ng-controller="SelectController as ctrl">
      Continent:
      <select id="continents" ng-model="ctrl.selectedContinent" ng-options="i.name for i in ctrl.continents" ng-change="ctrl.continentChanged()">
        <option value=''>Select</option>
      </select>
      
      <br/>
      
      Country:
      <select id="countries" ng-model="ctrl.selectedCountry" ng-options="i.name for i in ctrl.countries">
        <option value=''>Select</option>
      </select>
      
      <br/>
      
      City:
      <select id="cities" ng-model="ctrl.selectedCity" ng-options="i for i in ctrl.selectedCountry.cities">
        <option value=''>Select</option>
      </select>

      <hr/>
      <h3>selected values:</h3>
      
      <p>Continent: {{ ctrl.selectedContinent.name }} ({{ ctrl.selectedContinent.id }})</p>
      <p>Country: {{ ctrl.selectedCountry.name }}</p>
      <p>City: {{ ctrl.selectedCity }}</p>
      
      = {{ ctrl.c }} =
    </div>
  </body>

</html>
{% endhighlight %}

On line 15, we have added a `ng-change` attribute to the select form control.
That attribute tells AngularJS to invoke the method `continentChanged()` of the controller everytime the user changes the selection of the continent.

### The Javascript

{% highlight javascript linenos %}
// script.js

angular.module('SelectExampleApp', [])
  .controller('SelectController', function($http) {
    // results are stored in these 3 variables
    this.selectedContinent;
    this.selectedCountry;
    this.selectedCity;
    
    var that = this;
    
    $http({
      url: 'http://jsonstub.com/angularjs/select-example/continents',
      method: 'GET',
      dataType: 'json', 
      data: '',         
      headers: {
        'Content-Type': 'application/json',
        'JsonStub-User-Key': '7f32bb53-7f46-4760-948c-405725d8c533',
        'JsonStub-Project-Key': 'f84ee0a0-a600-45c5-bd2b-b2cc135e6f73'
      }
    }).success(function (data, status, headers, config) {
      that.continents = data;
    });
    
    this.continentChanged = function() {
      $http({
        url: 'http://jsonstub.com/angularjs/select-example/countries/' + that.selectedContinent.id,
        method: 'GET',
        dataType: 'json', 
        data: '',         
        headers: {
          'Content-Type': 'application/json',
          'JsonStub-User-Key': '7f32bb53-7f46-4760-948c-405725d8c533',
          'JsonStub-Project-Key': 'f84ee0a0-a600-45c5-bd2b-b2cc135e6f73'
        }
      }).success(function (data, status, headers, config) {
        that.countries = data;
      });
    };
  });
{% endhighlight %}

First, on line 12, we retrieve the list of continents via a REST API call instead of assigning to it a static array.
Nothing magic here, we are just getting data in a different way.

On line 26, we define the method `continentChanged()` referenced in the HTML code above. 
This method simply makes another REST API call to fetch the list of countries for the selected continent.
Then, it populates the variable `countries` used by the second select control.
Note the URL of the REST call contains `that.selectedContinent.id` which was set by the first select control.

We can repeat the same pattern to retrieve the list of cities for the selected country via a REST call, but I will leave that as an exercise for you to practice.

You can it in action on [Plunker](http://plnkr.co/b5LKYy)
