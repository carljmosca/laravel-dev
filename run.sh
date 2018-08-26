#!/bin/bash

# We are running this as a "random" user in the root group to be consistent with the default OCP configuration.

docker stop laravel-dev
docker rm laravel-dev
docker run -d --name laravel-dev \
  --user 1000001:0 \
  -p 80:8080 \
  -p 443:8443 \
  -e HTTPD_ONLINE=localhost:8080 \
  -e MYSQL_DATABASE=demoapp \
  -e MYSQL_USER=demoapp \
  -e MYSQL_PASSWORD=January12018! \
  -e MYSQL_HOST=192.168.1.28 \
  -e MYSQL_PORT=3306 \
  carljmosca/laravel-dev:1.00