<?php

declare(strict_types=1);

namespace minipress\core\actions;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class LogoutAction
{
    public function __invoke(Request $request, Response $response): Response
    {
        unset($_SESSION['user']);
        session_destroy();

        return $response
            ->withHeader('Location', '/login')
            ->withStatus(302);
    }
}
