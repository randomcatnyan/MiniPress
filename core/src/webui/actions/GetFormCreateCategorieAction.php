<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Views\Twig;

class GetFormCreateCategorieAction
{
    public function __invoke(Request $request, Response $response, array $args): Response
    {
        $view = Twig::fromRequest($request);

        return $view->render($response, 'create_categorie.twig', [
            'message' => null,
            'error' => null,
        ]);
    }
}
