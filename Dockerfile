FROM centos:7.4.1708

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum install -y yum-utils
RUN yum-config-manager --enable remi-php73  

RUN yum install -y httpd php php-common php-pdo php-mysql php-mbstring php-xml php-json php-zip \
    libmcrypt-dev libapache2-mod-php mod_ssl \
    mod_php mod_rewrite openssl \
    zip unzip

RUN chown -R 1000:0 /var/log
RUN chown -R 1000:0 /etc/httpd
RUN chown -R 1000:0 /etc/pki
RUN mkdir -p /var/run/httpd
RUN chown -R 1000:0 /var/run/httpd
RUN mkdir -p /var/lock/httpd
RUN chown -R 1000:0 /var/lock/httpd
RUN chown -R 1000:0 /tmp

RUN chmod -R 775 /var/log
RUN chmod -R 775 /etc/httpd
RUN chmod -R 775 /etc/pki
RUN chmod -R 775 /var/run/httpd
RUN chmod -R 775 /var/lock/httpd    

RUN sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
RUN sed -i 's/Listen 443/Listen 8443/g' /etc/httpd/conf.d/ssl.conf
RUN sed -i 's|DocumentRoot \"/var/www/html\"|DocumentRoot \"/home/apache/dev/public\"|g' /etc/httpd/conf/httpd.conf
RUN sed -i 's|/var/www/html|/home/apache/dev/public|g' /etc/httpd/conf/httpd.conf
RUN sed -i 's|/var/www|/home/apache/dev/public|g' /etc/httpd/conf/httpd.conf

RUN chmod g=u /etc/passwd

COPY image/*.sh /usr/local/bin/
RUN chmod 555 /usr/local/bin/*

RUN mkdir -p /home/apache/.composer/vendor/bin && \
    mkdir -p /home/apache/dev/public
COPY image/.htaccess /home/apache/dev/public
COPY image/.bash_profile /home/apache
RUN chmod -R 775 /home/apache && \
    chown -R 1001:0 /home/apache

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin && \
    php -r "unlink('composer-setup.php');" && \
    mv /usr/local/bin/composer.phar /usr/local/bin/composer

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]