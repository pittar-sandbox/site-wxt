#!/bin/bash

# Create the initial default settings.php file

settings_file=html/sites/default/settings.php;

if [ ! -f $settings_file ]; then
  echo "Create default settings.php file\n";
  chmod 775 html/sites/default;
  cp html/sites/default/default.settings.php $settings_file
  chmod 664 $settings_file
  chown --reference=. $settings_file
  mkdir html/sites/default/files
  chown --reference=. html/sites/default/files
  chmod 775 html/sites/default/files
fi

echo "\$settings['config_sync_directory'] = '/opt/app-root/src/data/config/default/sync';" >> $settings_file;
hashsalt=`drush php-eval 'echo \Drupal\Component\Utility\Crypt::randomBytesBase64(55)'`;
echo "\$settings['hash_salt'] = '$hashsalt';" >> $settings_file;

# This is a jquery fix that we need for some reason

if [ -d "html/libraries/jquery.inputmask/dist/min" ]; then
  echo "fix jquery inputmask distribution"
  echo "cp html/libraries/jquery.inputmask/dist/min/jquery.inputmask.bundle.min.js html/libraries/jquery.inputmask/dist/jquery.inputmask.min.js;"
        cp html/libraries/jquery.inputmask/dist/min/jquery.inputmask.bundle.min.js html/libraries/jquery.inputmask/dist/jquery.inputmask.min.js;
fi
if [ ! -d "html/libraries/jquery-ui-touch-punch" ]; then
  echo "mkdir html/libraries/jquery-ui-touch-punch;"
        mkdir html/libraries/jquery-ui-touch-punch;
  echo "wget https://raw.githubusercontent.com/furf/jquery-ui-touch-punch/master/jquery.ui.touch-punch.min.js;"
        wget https://raw.githubusercontent.com/furf/jquery-ui-touch-punch/master/jquery.ui.touch-punch.min.js;
  echo "mv jquery.ui.touch-punch.min.js html/libraries/jquery-ui-touch-punch;"
        mv jquery.ui.touch-punch.min.js html/libraries/jquery-ui-touch-punch;
fi

# Set up the default database if it has not already been configured

if ! grep -q "namespace' => 'Drupal" html/sites/default/settings.php; then
  echo "chmod 775 html/sites/default"
        chmod 775 html/sites/default
  echo "chmod 664 $settings_file"
        chmod 664 $settings_file
  echo "\$databases['default']['default'] = [" >> $settings_file
  echo "  'database' => ''," >> $settings_file
  echo "  'username' => getenv('DB_USERNAME')," >> $settings_file
  echo "  'password' => getenv('DB_PASSWORD')," >> $settings_file
  echo "  'prefix' => ''," >> $settings_file
  echo "  'host' => getenv('DB_HOST')," >> $settings_file
  echo "  'port' => getenv('DB_PORT')," >> $settings_file
  echo "  'namespace' => 'Drupal\\Core\\Database\\Driver\\pgsql'," >> $settings_file
  echo "  'driver' => 'pgsql'," >> $settings_file
  echo "];" >> $settings_file
  echo "chmod 555 html/sites/default"
        chmod 555 html/sites/default
fi

# For Drupal 9, need to create a soft-link

if [ ! -L html/modules/contrib/wxt_ext_translation ]; then
  pushd html/modules/contrib/
  ln -s ../../../custom/archives/wxt_ext_translation wxt_ext_translation
  popd
fi
