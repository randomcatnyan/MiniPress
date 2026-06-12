<?php

declare(strict_types=1);
require_once __DIR__ . '/../../vendor/autoload.php';

use minipress\core\utils\Eloquent;
use Slim\Views\Twig;
use Slim\Views\TwigMiddleware;
use Slim\Factory\AppFactory;
use minipress\core\webui\providers\AuthProvider;

Eloquent::init(__DIR__ . '/database.ini');
$app = AppFactory::create();
$twig = Twig::create(__DIR__ . '/../webui/views', [
    'cache' => false,
    'auto_reload' => true
]);

$auth = new AuthProvider();
$twig->getEnvironment()->addGlobal('user', $auth->getSignedInUser());


$app->add(TwigMiddleware::create($app, $twig));
$app->add(function ($request, $handler) {
    $response = $handler->handle($request);
    return $response
        ->withHeader('Access-Control-Allow-Origin', '*')
        ->withHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        ->withHeader('Access-Control-Allow-Headers', 'Content-Type');
});
$app->addRoutingMiddleware();
$app->addErrorMiddleware(true, false, false);


$routesFile = $routesFile;
$app = (require __DIR__ . '/' . $routesFile)($app);

return $app;
