FROM richarvey/nginx-php-fpm:php5

# add alpine edge repository
RUN echo http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    echo http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    apk update

# install nginx lua nodejs
RUN apk add --no-cache nginx-lua lua5.1 luarocks5.1 gcc musl-dev libc-dev lua-dev unzip curl nodejs
RUN luarocks-5.1 install lua-resty-http && luarocks-5.1 install luajwt

## install php debug
##RUN apk add --no-cache php5-xdebug

# Fix PHP.ini
RUN sed -i s/memory_limit\ =.*/memory_limit\ =\ 2048M/g /etc/php5/php.ini

## download & install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer

##npm install
RUN npm install -g bower --unsafe-perm
RUN npm install -g gulp --unsafe-perm
RUN npm install -g karma --unsafe-perm


#RUN apk del luarocks5.1 gcc libc-dev lua-dev unzip

RUN sed -i s/100M/200M/g /etc/php5/php-fpm.conf

##add right
ADD execute.sh /execute.sh
RUN chmod 755 /execute.sh