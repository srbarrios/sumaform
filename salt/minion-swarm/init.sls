suse-manager-pool-repo:
  file.managed:
    - name: /etc/zypp/repos.d/SUSE-Manager-3.0-x86_64-Pool.repo
    - source: salt://suse-manager/repos.d/SUSE-Manager-3.0-x86_64-Pool.repo
    - template: jinja
    - require:
      - sls: default

suse-manager-update-repo:
  file.managed:
    - name: /etc/zypp/repos.d/SUSE-Manager-3.0-x86_64-Update.repo
    - source: salt://suse-manager/repos.d/SUSE-Manager-3.0-x86_64-Update.repo
    - template: jinja
    - require:
      - sls: default

refresh-suse-manager-repos:
  cmd.run:
    - name: zypper --non-interactive --gpg-auto-import-keys refresh
    - require:
      - file: suse-manager-pool-repo
      - file: suse-manager-update-repo

{% if grains.has_key('swap_disk_device') %}
swap:
  cmd.run:
    - name: |
        parted -s /dev/{{grains['swap_disk_device']}} mklabel gpt
        parted -s /dev/{{grains['swap_disk_device']}} mkpart primary 0% 100%
        mkswap /dev/{{grains['swap_disk_device']}}1
        swapon -a
    - creates: /dev/{{grains['swap_disk_device']}}1
  mount.swap:
    - name: /dev/{{grains['swap_disk_device']}}1
    - persist: true
    - require:
      - cmd: swap

{% else %}

swap:
  cmd.run:
    - name: |
        fallocate --length {{grains["swap_file_size"]}}MiB /swapfile
        chmod 0600 /swapfile
        mkswap /swapfile
        swapon -a
    - creates: /swapfile
  mount.swap:
    - name: /swapfile
    - persist: true
    - require:
      - cmd: swap
{% endif %}

salt-master:
  pkg.installed:
    - require:
      - cmd: refresh-suse-manager-repos

minion-swarm-script:
  file.managed:
    - name: /usr/bin/minionswarm.py
    - source: salt://minion-swarm/minionswarm.py
    - mode: 700
    - require:
      - pkg: salt-master
      - mount: swap

minion-swarm-service:
  file.managed:
    - name: /etc/systemd/system/minion-swarm.service
    - contents: |
        [Unit]
        Description=Minion Swarm Host

        [Service]
        ExecStart=/usr/bin/minionswarm.py --minions {{grains["minion-count"]}} --master {{grains['server']}} --name {{grains['hostname']}} --no-clean --temp-dir=/tmp/swarm --rand-machine-id --rand-ver

        [Install]
        WantedBy=multi-user.target
    - require:
      - file: minion-swarm-script
  service.running:
    - name: minion-swarm
    - enable: True
    - require:
      - file: minion-swarm-service
