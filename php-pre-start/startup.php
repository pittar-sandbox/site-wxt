#!/usr/bin/env php
<?php

file_put_contents('/opt/app-root/src/a', "This is a file.\n");

file_put_contents('b', "This is the b file.\n");

include_once 'html/sites/sites.php';

file_put_contents('/opt/app-root/src/sites', print_r($sites, true));

chdir('/opt/app-root/src/html');
foreach ($sites as $name) {
  symlink('.', $name);
}
