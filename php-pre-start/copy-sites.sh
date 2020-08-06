#!/bin/bash

if [ -f /opt/app-root/src/html/sites/default/settings.php ]; then
    echo "Data exists, skip copying default data."
else
    echo "Data dir empty.  Copy default data."
    if [[ -d /opt/app-root/src/data && ! -d /opt/app-root/src/data/sites ]]; then
        mkdir /opt/app-root/src/data/sites
    fi
    cp -R /opt/app-root/src/html/tempsite/* /opt/app-root/src/html/sites
fi
