# install composer from the official composer docker image
FROM composer as builder
RUN git config --global url."https://github.com/".insteadOf git@github.com:

# add the sclorg php image
FROM registry.apps.dev.ocp-dev.ised-isde.canada.ca/ised-ci/sclorg-s2i-php:7.3

USER root
COPY --from=builder /usr/bin/composer /usr/bin/composer
COPY composer.* ./

#ENV COMPOSER_FILE=composer-installer \
#    
# set up env vars 
ENV DOCUMENTROOT=/html \
  PATH=/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/app-root/src/vendor/bin \
  COMPOSER_MEMORY_LIMIT=-1
  
#RUN curl -s -o $COMPOSER_FILE https://getcomposer.org/installer && \
#    php $COMPOSER_FILE --version=2.0.8

RUN yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    yum --disablerepo=rhel-8-for-x86_64-appstream-rpms install -y postgresql12 && \
    yum clean all

COPY / /opt/app-root/src

WORKDIR /opt/app-root/src

RUN chgrp -R 1001 /opt/app-root/src && \
    chown -R 1001 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

# Do not run composer as root  
USER 1001

#RUN ./composer.phar clearcache && \
#    ./composer.phar install --no-interaction --no-ansi --optimize-autoloader
RUN /usr/bin/composer clearcache && composer install --no-interaction --no-ansi --optimize-autoloader

USER root

RUN mkdir -p /opt/app-root/src/data/sites && \
    rm -rf /opt/app-root/src/html/sites && \
    ln -s /opt/app-root/src/data/sites /opt/app-root/src/html/sites

RUN chgrp -R 1001 /opt/app-root/src && \
    chown -R default /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src && \
    chgrp -R 0 /run/httpd && \ 
    chmod -R g=u /run/httpd

USER 1001



ENTRYPOINT ["bin/run"]
