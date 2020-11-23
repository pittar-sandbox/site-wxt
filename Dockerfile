FROM registry.apps.dev.ocp-dev.ised-isde.canada.ca/ised-ci/sclorg-s2i-php:7.3

USER root

# Update the image with the latest packages (recommended), then
# Install php-xmlrpc module from RHSCL repo, remove override_install_langs so all locales can be installed, install glibc-common for all locales (locale -a)
RUN yum update -y && \
    yum clean all && \
    yum install -y php-xmlrpc && \
    yum install -y php-zip && \
    yum install -y langpacks-fr  && \
    yum reinstall -y --allowerasing glibc-common && \
    yum clean all

ENV COMPOSER_FILE=composer-installer \
    DOCUMENTROOT=/html

RUN curl -s -o $COMPOSER_FILE https://getcomposer.org/installer && \
    php $COMPOSER_FILE --version=1.10.15

RUN yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    yum --disablerepo=rhel-8-for-x86_64-appstream-rpms install -y postgresql12 && \
    yum clean all

COPY / /opt/app-root/src

WORKDIR /opt/app-root/src

RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

#do not run composer as root, according to the documentation
USER 1001
RUN ./composer.phar clearcache && \
    ./composer.phar install --no-interaction --no-ansi --optimize-autoloader
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
