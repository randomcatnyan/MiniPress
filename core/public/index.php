<?php

declare(strict_types=1);

use minipress\core\conf\Bootstrap;
use minipress\core\webui\providers\WebUIRouteProvider;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Slim\Factory\AppFactory;
use Slim\Views\Twig;
use Slim\Views\TwigMiddleware;
use Slim\Csrf\Guard;

require __DIR__ . '/../vendor/autoload.php';


Bootstrap::initEloquent();


$app = AppFactory::create();


$twig = Twig::create(__DIR__ . '/../src/webui/views', ['cache' => false]);
$app->add(TwigMiddleware::create($app, $twig));


$responseFactory = $app->getResponseFactory();
$guard = new Guard($responseFactory);
$guard->setPersistentTokenMode(true);


$app->add(function (Request $request, RequestHandler $handler) use ($guard): Response {
    $csrfNameKey = $guard->getTokenNameKey();
    $csrfValueKey = $guard->getTokenValueKey();
    $csrfName = $guard->getTokenName();
    $csrfValue = $guard->getTokenValue();

    $view = Twig::fromRequest($request);
    $view->getEnvironment()->addGlobal('csrf', [
        'field' => '<input type="hidden" name="' . $csrfNameKey . '" value="' . $csrfName . '">' .
                   '<input type="hidden" name="' . $csrfValueKey . '" value="' . $csrfValue . '">',
    ]);

    return $handler->handle($request);
});

$app->add($guard);


WebUIRouteProvider::register($app);


$app->addErrorMiddleware(true, true, true);

$app->run();
