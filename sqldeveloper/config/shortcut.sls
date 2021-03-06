# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqldeveloper as s with context %}

    {%- if grains.kernel|lower in ('linux',) and s.linux.install_desktop_file %}
        {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ tplroot ~ '.archive.install' }}

sqldeveloper-config-file-file-managed-desktop-shortcut_file:
  file.managed:
    - name: {{ s.linux.desktop_file }}
    - source: {{ files_switch(['shortcut.desktop.jinja'],
                              lookup='sqldeveloper-config-file-file-managed-desktop-shortcut_file'
                 )
              }}
    - mode: 644
    - user: {{ s.identity.user }}
    - makedirs: True
    - template: jinja
    - context:
        appname: {{ s.pkg.name }}
        edition: ''
        command: {{ s.command|json }}
        path: {{ s.path }}
    - onlyif: test -f {{ s.path }}/{{ s.command }}
    - require:
      - sls: {{ tplroot ~ '.archive.install' }}

    {%- endif %}
