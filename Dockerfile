FROM image-registry.openshift-image-registry.svc:5000/drupal-wxt/sclorg-s2i-php:latest

USER root

ENV COMPOSER_FILE=composer-installer \
    DOCUMENTROOT=/html

RUN curl -s -o $COMPOSER_FILE https://getcomposer.org/installer && \
    php $COMPOSER_FILE --version=2.0.8

RUN yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    install postgresql12 && \
    yum clean all

COPY / /opt/app-root/src

WORKDIR /opt/app-root/src

RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

# Do not run composer as root
USER 1001

# When building images in Docker, uncomment these lines
#RUN ./composer.phar clearcache && \
#    ./composer.phar install --no-interaction --no-ansi --optimize-autoloader

RUN ./composer.phar check-platform-reqs
USER root

RUN mkdir -p /opt/app-root/src/data/sites && \
    rm -rf /opt/app-root/src/html/sites && \
    ln -s /opt/app-root/src/data/sites /opt/app-root/src/html/sites

RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src && \
    chgrp -R 0 /run/httpd && \ 
    chmod -R g=u /run/httpd

USER 1001

ENTRYPOINT ["bin/run"]
