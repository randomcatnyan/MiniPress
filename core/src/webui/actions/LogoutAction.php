<?php

declare(strict_types=1);

namespace minipress\core\actions;

use Slim\Routing\RouteContext;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class LogoutAction
{
    public function __invoke(Request $request, Response $response): Response
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        session_unset();
        session_destroy();
        $routeParser = RouteContext::fromRequest($request)->getRouteParser();
        return $response->withHeader('Location', '/login')->withStatus(302);
    }
}
