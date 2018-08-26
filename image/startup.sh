#!/bin/bash

source /home/apache/.bash_profile

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "apache:x:$(id -u):0:apache user:/home/apache:/bin/bash" >> /etc/passwd
  fi
fi

#/usr/local/bin/setenv.sh /etc/httpd/conf.d/servername.conf

php /usr/local/bin/composer global require "laravel/installer"    

apachectl

tail -f /dev/null