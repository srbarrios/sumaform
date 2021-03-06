include:
  - suse_manager_server.initial_content

{% if grains['iss_slave'] %}

register_slave:
  cmd.script:
    - name: salt://suse_manager_server/register_slave.py
    - args: "{{ grains.get('server_username') | default('admin', true) }} {{ grains.get('server_password') | default('admin', true) }} {{ grains.get('fqdn') | default('localhost', true) }} {{ grains['iss_slave'] }}"
    - require:
      - sls: suse_manager_server.initial_content

{% elif grains['iss_master'] %}

register_master:
  cmd.script:
    - name: salt://suse_manager_server/register_master.py
    - args: "{{ grains.get('server_username') | default('admin', true) }} {{ grains.get('server_password') | default('admin', true) }} {{ grains['iss_master'] }} {{ grains.get('fqdn') | default('localhost', true) }}"
    - require:
      - sls: suse_manager_server.initial_content

master_ssl_cert:
  file.managed:
    - name: /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT
    - source: http://{{grains['iss_master']}}/pub/RHN-ORG-TRUSTED-SSL-CERT
    - source_hash: http://{{grains['iss_master']}}/pub/RHN-ORG-TRUSTED-SSL-CERT.sha512
    - require:
      - sls: suse_manager_server.initial_content

{% endif %}
