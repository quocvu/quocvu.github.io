---
layout: resume
title: Quoc Vu's Resume
tags: [quoc vu, resume, skill, experience, education]
modified: 2014-08-08T20:53:07.573882-04:00
comments: false
resume: visual
share: false
image:
  feature: mountains.jpg
  credit:
  creditlink:
---

<div id="instructions">Mouse over for details</div>

<div id="subway-map" data-columns="12" data-rows="7" data-cellSize="60" data-legendId="legend" data-textClass="text" data-gridNumbers="true" data-grid="false" data-lineWidth="8">
  <ul data-color="#0064D4" data-label="Experience">
    <li data-coords="6,4" data-marker="interchange" data-labelPos="S"><a href="summary">Summary</a></li>
{% for exp in site.data.resume.experience %}
    <li data-coords="{{ exp.subway.coords }}" data-marker="station" data-labelPos="{{ exp.subway.label }}" {% if exp.subway.dir %}data-dir="{{ exp.subway.dir }}"{% endif %}><a href="{{ exp.id }}">{% if exp.company-abbr %} {{ exp.company-abbr }} {% else %} {{ exp.company }} {% endif %}</a></li>
{% endfor %}
  </ul>

  <ul data-color="#E63339" data-label="Skills">
    <li data-coords="6,4" data-marker="interchange" data-labelPos="S"></li>
{% for skill in site.data.resume.skills %}
    <li data-coords="{{ skill.subway.coords }}" data-marker="station" data-labelPos="{{ skill.subway.label }}" {% if skill.subway.dir %}data-dir="{{ skill.subway.dir }}"{% endif %}><a href="{{ skill.id }}">{{ skill.title }}</a></li>
{% endfor %}
  </ul>

  <ul data-color="#87B716" data-label="Education" data-shiftCoords="1,0">
    <li data-coords="6,4" data-marker="interchange" data-labelPos="S"></li>
{% for edu in site.data.resume.education %}
    <li data-coords="{{ edu.subway.coords }}" data-marker="station" data-labelPos="{{ edu.subway.label }}" {% if edu.subway.dir %}data-dir="{{ edu.subway.dir }}"{% endif %}><a href="{{ edu.id }}">{{ edu.degree-abbr }}</a></li>
{% endfor %}
  </ul>

  <ul data-color="#F6B002" data-label="Publications">
      <li data-coords="6,4" data-marker="interchange" data-labelPos="S"></li>
      <li data-coords="6,3" data-marker="station" data-labelPos="E"><a href="patents">Patents</a></li>
      <li data-coords="6,2" data-marker="station" data-labelPos="E"><a href="journals">Journals</a></li>
      <li data-coords="7,1" data-marker="station" data-labelPos="E" data-dir="N"><a href="conferences">Conferences</a></li>
  </ul>
</div>
<div id="legend"></div>

<script type="text/javascript">
$('#subway-map').subwayMap({ debug: true });

  // the selector is applied to the DOM after subwayMap modified it
  $('#subway-map > .text').webuiPopover({
    trigger: 'hover',
    type: 'html',
    width: 550,
    placement: 'auto',
    title: function() {
      var id = $(this).attr('href');
      return $(document).find('#data > li#' + id + ' > .title').html();
    },
    content: function() {
      var id = $(this).attr('href');
      return $(document).find('#data > li#' + id + ' > .description').html();
    }
  });

$(document).ready(function() {
  $('#data').hide();
});
</script>

<ul id="data">
  <li id="summary">
    <div class="title">Summary</div>
    <div class="description">
      <ul>
  {% for desc in site.data.resume.summary %}
        <li>{{ desc }}</li>
  {% endfor %}
      </ul>
    </div>
  </li>


{% for exp in site.data.resume.experience %}
  <li id="{{ exp.id }}">
    <div class="title">
      <p class="job-title">{{ exp.title }}</p>
      <p class="company">@ {{ exp.company }}</p>
      <p class="period">{{ exp.period }}</p>
    </div>
    <div class="description">
      <ul>
  {% for desc in exp.desc %}
        <li>{{ desc }}</li>
  {% endfor %}
      </ul>
    </div>
  </li>
{% endfor %}

{% for skill in site.data.resume.skills %}
  <li id="{{ skill.id }}">
    <div class="title">{{ skill.title }}</div>
    <div class="description">
      <ul>
  {% for i in skill.list %}
        <li>{{ i }}</li>
  {% endfor %}
      </ul>
    </div>
  </li>
{% endfor %}

{% for edu in site.data.resume.education %}
  <li id="{{ edu.id }}">
    <div class="title">{{ edu.degree }}</div>
    <div class="description">
      @ {{ edu.institution }}<br/>
      {{ edu.location }}<br/>
      {{ edu.period }}<br/>
    </div>
  </li>
{% endfor %}

  <li id="patents">
    <div class="title">6 Patents</div>
    <div class="description">
      <ul>
{% for i in site.data.resume.papers.patents %}
        <li>{{ i.author }}, "{{ i.title }}", {{ i.number }}, {{ i.issued_at }}</li>
{% endfor %}
      </ul>
    </div>
  </li>

  <li id="journals">
    <div class="title">5 Journal Articles</div>
    <div class="description">
      <ul>
{% for i in site.data.resume.papers.journals %}
        <li>{{ i.author }}, "{{ i.title }}", in {{ i.journal }}</li>
{% endfor %}
      </ul>
    </div>
  </li>

  <li id="conferences">
    <div class="title">9 Conference Papers</div>
    <div class="description">
      <ul>
{% for i in site.data.resume.papers.conferences %}
        <li>{{ i.author }}, "{{ i.title }}", in {{ i.conference }}</li>
{% endfor %}
      </ul>
    </div>
  </li>
</ul>

