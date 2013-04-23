include:
  - nginx

/etc/nginx/sites-enabled/stub-status:
  file.symlink:
    - target: ../sites-available/stub-status
