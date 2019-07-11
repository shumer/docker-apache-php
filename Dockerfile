
FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils php php-phar php-iconv php-mysql wget \
    curl php-curl php-mbstring php-dom php-gd php-xdebug php-zip php-ldap sendmail \
    apache2 memcached php-memcached mc mysql-client htop git gnupg2


ENV WEB_SERVER_DOCROOT=docroot
ADD ./apache.conf /etc/apache2/sites-available/
ADD ./apache-ssl.conf /etc/apache2/sites-available/
ADD ./php.ini /tmp/php.ini
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf && \
    ln -s /etc/apache2/sites-available/apache.conf /etc/apache2/sites-enabled/ && \
    ln -s /etc/apache2/sites-available/apache-ssl.conf /etc/apache2/sites-enabled/ && \
    a2enmod rewrite && a2enmod headers && a2enmod ssl && \
    wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x mhsendmail_linux_amd64 && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail && \
    cat /tmp/php.ini >> /etc/php/7.2/apache2/php.ini && \
    cat /tmp/php.ini >> /etc/php/7.2/cli/php.ini && \
    git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && \
    ~/.bash_it/install.sh && \
    sed -i -e 's/bobby/powerline-plain/g' /root/.bashrc && \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    cp wkhtmltox/bin/wk* /usr/local/bin/ && \
    rm wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    apt-get install libfontconfig1 libxrender1 composer npm -y && \
    apt-get update && apt-get install libssl1.0-dev php-bcmath jq sudo -y && \
    npm install -g yarn

WORKDIR /var/www/html

CMD apachectl -D FOREGROUND