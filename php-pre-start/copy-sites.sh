#!/bin/bash

/usr/bin/php $(dirname $0)/startup.php

if [ -f /opt/app-root/src/html/sites/default/settings.php ]; then
    echo "Data exists, skip copying default data."
else
    echo "Data dir empty.  Copy default data."
    if [[ -d /opt/app-root/src/data && ! -d /opt/app-root/src/data/sites ]]; then
        mkdir /opt/app-root/src/data/sites
    fi

    # Create the initial default settings.php file
    cp -R /opt/app-root/src/html/tempsite/* /opt/app-root/src/html/sites

    pushd html/sites/default

    if [ ! -f settings.php ]; then
      echo "Create default settings.php file\n";
      chmod 775 html/sites/default;
      cp html/sites/default/default.settings.php settings.php
      chmod 664 settings.php
      chown --reference=. settings.php
      mkdir html/sites/default/files
      chown --reference=. html/sites/default/files
      chmod 775 html/sites/default/files
    fi

    echo "\$settings['config_sync_directory'] = '/opt/app-root/src/data/config/default/sync';" >> settings.php;
    hashsalt=`vendor/bin/drush php-eval 'echo \Drupal\Component\Utility\Crypt::randomBytesBase64(55)'`;
    echo "\$settings['hash_salt'] = '$hashsalt';" >> settings.php;

    # Set up the default database if it has not already been configured
    
    if ! grep -q "namespace' => 'Drupal" settings.php; then
      echo "\$databases['default']['default'] = [" >> settings.php
      echo "  'database' => 'drupal_db'," >> settings.php
      echo "  'username' => getenv('DB_USERNAME')," >> settings.php
      echo "  'password' => getenv('DB_PASSWORD')," >> settings.php
      echo "  'prefix' => ''," >> settings.php
      echo "  'host' => getenv('DB_HOST')," >> settings.php
      echo "  'port' => getenv('DB_PORT')," >> settings.php
      echo "  'namespace' => 'Drupal\\Core\\Database\\Driver\\pgsql'," >> settings.php
      echo "  'driver' => 'pgsql'," >> settings.php
      echo "];" >> settings.php
      echo "chmod 555 html/sites/default"
            chmod 555 html/sites/default
    fi

    popd
fi

if [ ! -d /opt/app-root/src/data/config ]; then
    mkdir -p /opt/app-root/src/data/config/sync
fi
