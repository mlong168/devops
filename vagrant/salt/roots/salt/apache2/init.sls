apache2-pkgs:
  pkg:
    - latest
    - names:
      - apache2
      - libapache2-mod-wsgi
      - apache2-mpm-prefork

# TODO conf needed to be added
#/etc/nginx/nginx.conf:
#  file:
#    - managed
#    - source: salt://apache2/conf/httpd.conf
#    - user: appannie
#    - group: appannie
#    - mode: 754
#    - require:
#      - pkg: apache2-pkgs
#
#apache2:
#  service:
#    - running
#    - enable: True    
#    - watch:
#      - file: /etc/apache2/httpd.conf
