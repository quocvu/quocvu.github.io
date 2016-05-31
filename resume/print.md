---
layout: page
title: Quoc Vu's Resume
tags: [quoc vu, resume, skill, experience, education]
modified: 2014-08-08T20:53:07.573882-04:00
resume: print
comments: false
share: false
image:
  feature: mountains.jpg
  credit: 
  creditlink: 
---

## Summary

{% for summary in site.data.resume.summary %}
* {{ summary }}{% endfor %}

## Experience

{% for exp in site.data.resume.experience %}

#### {{ exp.title }} @ {{ exp.company }}

{{ exp.period }}

{% for desc in exp.desc %}
* {{ desc }}{% endfor %}

{% endfor %}

## Technical Skills

{% for skill in site.data.resume.skills %}

#### {{ skill.title }}

{% for i in skill.list %}
* {{ i }}{% endfor %}

{% endfor %}

## Education

{% for edu in site.data.resume.education %}
#### {{ edu.degree }} 
@ {{ edu.institution }}  
{{ edu.location }}  
{{ edu.period }}  
{% endfor %}

## Patents and Publications

#### Patents

{% for p in site.data.resume.papers.patents %}
* {{ p.author }}, "{{ p.title }}", {{ p.number }}, {{ p.issued_at }}{% endfor %}

#### Journal Articles

{% for p in site.data.resume.papers.journals %}
* {{ p.author }}, "{{ p.title }}", in {{ p.journal }}{% endfor %}

#### Conference Papers

{% for p in site.data.resume.papers.conferences %}
* {{ p.author }}, "{{ p.title }}", in {{ p.conference }}{% endfor %}
