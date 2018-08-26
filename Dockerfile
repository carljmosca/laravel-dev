FROM centos:7.4.1708

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum install -y yum-utils
RUN yum-config-manager --enable remi-php73  

RUN yum install -y httpd php php-common php-pdo php-mysql php-mbstring php-xml php-json php-zip \
    libmcrypt-dev libapache2-mod-php mod_ssl \
    mod_php mod_rewrite openssl \
    zip unzip

RUN chmod g=u /etc/passwd

COPY image/*.sh /usr/local/bin/
RUN chmod 555 /usr/local/bin/*

RUN mkdir -p /home/apache/.composer/vendor/bin && \
    mkdir /home/apache/dev
COPY image/.bash_profile /home/apache
RUN chmod -R 775 /home/apache && \
    chown -R 1001:0 /home/apache

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin && \
    php -r "unlink('composer-setup.php');" && \
    mv /usr/local/bin/composer.phar /usr/local/bin/composer

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]