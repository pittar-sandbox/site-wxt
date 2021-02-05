#!/usr/bin/env php
<?php

chdir('/opt/app-root/src/html');
symlink('../vendor/ised-isde/remote-manage/rmanage.php', 'rmanage.php');

// If this has a multisite configuration, create soft-links in the docroot
if (file_exists('sites/sites.php')) {
  include_once 'sites/sites.php';
  foreach ($sites as $name) {
    symlink('.', $name);
  }
}
