include:
  - apt

aa_webserver_dependencies:
  pkg:
    - latest
    - names:
      - python-psycopg2
      - python-lxml
      - python-crypto
      - python-redis
      - python-simplejson
      - python-urlgrabber
      - python-pygooglechart
      - python-geoip
      - python-markdown
      - pyflakes
      - python-pip
      - python-recaptcha
      - python-pycurl
      - python-tz
    - require:
      - cmd: apt-update


aa_scrape_dependencies:
  pkg:
    - latest
    - names:
      - python-sqlalchemy
      - python-boto
      - python-twisted
      - python-pybabel
      - python-xlwt
      - mailutils
    - require:
      - cmd: apt-update


aa_language_dependencies:
  pkg:
    - latest
    - names:
      - openjdk-6-jre-headless
      - python-dev
    - require:
      - cmd: apt-update


aa_pip_requirements:
  pip.installed:
    - requirements: salt://aa_dependencies/requirements.txt
    - require:
      - pkg: aa_webserver_dependencies
