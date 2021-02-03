#!/usr/bin/env php
<?php

include_once 'html/sites/sites.php';

chdir('/opt/app-root/src/html');
foreach ($sites as $name) {
  symlink('.', $name);
}

symlink('../vendor/ised-isde/remote-manage/rmanage.php', 'rmanage.php');
