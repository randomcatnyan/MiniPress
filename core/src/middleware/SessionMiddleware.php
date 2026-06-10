<?php

declare(strict_types=1);

namespace minipress\core\middleware;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Slim\Views\Twig;

class SessionMiddleware implements MiddlewareInterface
{
    public function process(Request $request, RequestHandlerInterface $handler): Response
    {
        $view = Twig::fromRequest($request);
        $view->getEnvironment()->addGlobal('session', $_SESSION);

        return $handler->handle($request);
    }
}
