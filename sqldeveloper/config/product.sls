# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqldeveloper with context %}

    {%- if grains.kernel|lower in ('linux',) %}
           {%- if sqldeveloper.pkg.use_upstream_macapp %}
                  {%- set sls_package_install = tplroot ~ '.macapp.install' %}
           {%- else %}
                  {%- set sls_package_install = tplroot ~ '.archive.install' %}
           {%- endif %}

include:
  - {{ sls_package_install }}

sqldeveloper-config-file-managed-product_file:
  file.managed:
    - name: {{ sqldeveloper.dir.homes ~ '/' ~ sqldeveloper.identity.user ~ '/.sqldeveloper' }}/{{ sqldeveloper.release }}/product.conf  # noqa 204
    - mode: 640
    - user: {{ sqldeveloper.identity.user }}
    - group: {{ sqldeveloper.identity.rootgroup }}
    - makedirs: True
    - contents:
      - SetJavaHome /usr/lib/java
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
