<?php

declare(strict_types=1);

session_start();

require_once __DIR__ . '/../../vendor/autoload.php';

$routesFile = 'routesAdmin.php';
$app = require __DIR__ . '/../../src/conf/bootstrap.php';

$app->run();
