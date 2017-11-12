---
layout: page
title: Quoc Vu's Resume
tags: [quoc vu, resume, skill, experience, education]
modified: 2014-08-08T20:53:07.573882-04:00
resume: print
comments: false
share: false
width: 1000px
image:
  feature: mountains.jpg
  credit:
  creditlink:
---
{% for i in site.data.resume.summary %}
  * {{ i }}{% endfor %}  

<section id="cd-timeline" class="cd-container">

{% assign events = site.data.resume.events | sort: 'date.from' | reverse %}
{% for event in events %}
  <div class="cd-timeline-block">
    <div class="cd-timeline-img cd-{{ event.type}}">
      <img src="/images/{{ event.type }}.png" alt="Work">
    </div> <!-- cd-timeline-img -->

    <div class="cd-timeline-content">
  {% if event.type == 'work' %}
      <h2>{{ event.title }}</h2>
      <p>{{ event.date.from }} - {{ event.date.to }} @{{ event.company }}</p>
      <ul class="description">
    {% for i in event.description %}
        <li>{{ i }}</li>
    {% endfor %}
      </ul>
  {% elsif event.type == 'skill' %}
      <h2>{{ event.title }}</h2>
  {% elsif event.type == 'education' %}
      <h2>{{ event.degree }}</h2>
      <p>{{ event.date.from }} - {{ event.date.to }}
      @ {{ event.institution }} ({{ event.location }})</p>
  {% elsif event.type == 'publication' %}
      <h2>{{ event.title }}</h2>
      <p>{{ event.journal }}{{ event.conference }}{{ event.number }}</p>
  {% endif %}      
    </div>
    <div class="cd-date"><h2>{{ event.date.from }}</h2></div>
  </div> <!-- cd-timeline-block -->
{% endfor %}

</section> <!-- cd-timeline -->
