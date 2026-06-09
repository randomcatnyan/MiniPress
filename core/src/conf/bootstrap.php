<?php
declare(strict_types=1);
require_once __DIR__ . '/../../vendor/autoload.php';

use minipress\core\utils\Eloquent;
use Slim\Views\Twig;
use Slim\Views\TwigMiddleware;
Eloquent::init(__DIR__ . '/../.database_env');
$app = \Slim\Factory\AppFactory::create();
$twig = Twig::create(__DIR__ . '/../webui/views', [
    'cache' => false, 
    'auto_reload' => true
]);
$app->add(TwigMiddleware::create($app, $twig));
$app->addRoutingMiddleware();
$app->addErrorMiddleware(true, false, false);
$app = (require_once __DIR__ . '/routes.php')($app);

return $app;