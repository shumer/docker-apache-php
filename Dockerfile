FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils php php-phar php-iconv php-mysql wget \
    curl php-curl php-mbstring php-dom php-gd sendmail \
    apache2 memcached php-memcached mc mysql-client htop

ADD ./apache.conf /etc/apache2/sites-available/
ADD ./apache-ssl.conf /etc/apache2/sites-available/
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf && \
    ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/ && \
    ln -s /etc/apache2/sites-available/apache-ssl.conf /etc/apache2/sites-enabled/ && \
    a2enmod rewrite && a2enmod headers && a2enmod ssl \
    wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x mhsendmail_linux_amd64 && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail && \
    echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025 --from=no-reply@docker.docker"' >> /etc/php/7.2/cli/php.ini && \
    echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025 --from=no-reply@docker.docker"' >> /etc/php/7.2/apache2/php.ini && \
    echo "memory_limit=512M" >> /etc/php/7.2/apache2/php.ini && \
    echo "max_execution_time=90" >> /etc/php/7.2/apache2/php.ini && \
    echo "memory_limit=512M" >> /etc/php/7.2/cli/php.ini && \
    echo "max_execution_time=90" >> /etc/php/7.2/cli/php.ini
CMD apachectl -D FOREGROUND
