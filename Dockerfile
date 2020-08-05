FROM registry.apps.dev.openshift.ised-isde.canada.ca/ciodrcoe-dev/sclorg-s2i-php:7.3

USER root

ENV COMPOSER_FILE=composer-installer \
    DOCUMENTROOT=/html

RUN curl -s -o $COMPOSER_FILE https://getcomposer.org/installer && \
    php <$COMPOSER_FILE

RUN yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    yum --disablerepo=rhel-8-for-x86_64-appstream-rpms install -y postgresql12 && \
    yum clean all

COPY / /opt/app-root/src

WORKDIR /opt/app-root/src

RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

#do not run composer as root, according to the documentation
USER 1001
RUN ./composer.phar install --no-interaction --no-ansi --optimize-autoloader
USER root

RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src && \
    chgrp -R 0 /run/httpd && \ 
    chmod -R g=u /run/httpd

USER 1001

ENTRYPOINT ["bin/run"]
