include:
  - apt

default:
  pkg:
    - latest
    - names:
      - aptitude
      - build-essential
      - etckeeper
      - git
      - htop
      - linux-headers-virtual
      - linux-image-virtual
      - linux-virtual
      - logrotate
      - realpath
      - salt-minion
      - sudo
      - tmux
    - require:
      - cmd: apt-upgrade
