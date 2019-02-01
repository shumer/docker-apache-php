#Download base image ubuntu latest
FROM ubuntu:latest

ARG PHP_MEMORY_LIMIT=512M
ENV PHP_MAX_EXECUTION_TIME=90
ENV PHP_MEMORY_LIMIT=$PHP_MEMORY_LIMIT
 
# Update Software repository
RUN apt-get update
 
# Install nginx, php-fpm and supervisord from ubuntu repository
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils php php-phar php-iconv php-mysql wget\
    curl php-curl php-mbstring php-dom php-gd sendmail \
    apache2 memcached php-memcached mc mysql-client htop

# Configuration for Apache
ADD ./apache.conf /etc/apache2/sites-available/
ADD ./apache-ssl.conf /etc/apache2/sites-available/
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf && \
    ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/ && \
    ln -s /etc/apache2/sites-available/apache-ssl.conf /etc/apache2/sites-enabled/ && \
    a2enmod rewrite && a2enmod headers && \
    wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x mhsendmail_linux_amd64 && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail
RUN echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025 --from=no-reply@docker.docker"' >> /etc/php/7.2/cli/php.ini
RUN echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025 --from=no-reply@docker.docker"' >> /etc/php/7.2/apache2/php.ini
RUN echo "memory_limit = ${PHP_MEMORY_LIMIT}" >> /etc/php/7.2/apache2/php.ini
RUN echo "max_execution_time = ${PHP_MAX_EXECUTION_TIME}" >> /etc/php/7.2/apache2/php.ini
CMD apachectl -D FOREGROUND
