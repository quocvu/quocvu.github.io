---
layout: pdf
title: Quoc Vu's Resume
tags: [quoc vu, resume, skill, experience, education]
modified: 2014-08-08T20:53:07.573882-04:00
---


## Summary

{% for summary in site.data.resume.summary %}
* {{ summary }}{% endfor %}

## Experience

{% assign events = site.data.resume.events | sort: 'date.from' | reverse %}
{% for event in events %}
  {% if event.type == 'work' %}
#### {{ event.date.from }} - {{ event.date.to }}: {{ event.title }} @{{ event.company }}

    {% if event.summary %}
{{ event.summary }}
    {% else %}
      {% for i in event.description %}
* {{ i }}{% endfor %}      
    {% endif %}
  {% endif %}      
{% endfor %}

## Education

{% for event in events %}{% if event.type == 'education' %}
* {{ event.date.to }}: {{ event.degree }}, {{ event.institution }}{% endif %}    {% endfor %}

## Technical Skills

{% for event in events %}{% if event.type == 'skill' %}
* {{ event.date.from }}: {{ event.title }}{% endif %}{% endfor %}


## Patents and Publications

* 4 Patents issued
* 5 Journal papers
* 9 Conference papers
