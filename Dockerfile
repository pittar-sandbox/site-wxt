FROM registry.apps.dev.ocp-dev.ised-isde.canada.ca/ised-ci/sclorg-s2i-php:7.3

USER root

ENV COMPOSER_FILE=composer-installer \
    DOCUMENTROOT=/html

RUN curl -s -o $COMPOSER_FILE https://getcomposer.org/installer && \
    php $COMPOSER_FILE --version=2.0.8

RUN yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    yum --disablerepo=rhel-8-for-x86_64-appstream-rpms install -y postgresql12 && \
    yum clean all

COPY / /opt/app-root/src

WORKDIR /opt/app-root/src

RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

# Do not run composer as root
USER 1001
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
