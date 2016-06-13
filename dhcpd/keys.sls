{% from "dhcpd/map.jinja" import dhcpd with context %}

include:
  - dhcpd

{%- for key_name, values in salt['pillar.get']('dhcpd:keys', {}).items() %}
dhcpd.conf:
  file.managed:
    {%- set path = [dhcpd.key_path, key_name + ".key"] %}
    - name: {{ '/'.join(path) }}
    - source: salt://dhcpd/files/ddns-key.jinja
    - template: jinja
    - defaults:
        name: {{ key_name }}
        values: {{ values }}
    - user: root
{%- if 'BSD' in salt['grains.get']('os') %}
    - group: wheel
{%- else %}
    - group: root
{%- endif %}
    - mode: 600
    - watch_in:
      - service: dhcpd
{%- endfor %}
