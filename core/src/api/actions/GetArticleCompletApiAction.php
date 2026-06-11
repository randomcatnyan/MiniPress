<?php
declare(strict_types=1);

namespace minipress\core\api\actions;

use minipress\core\application_core\application\usecases\ArticleManagementService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;
use Slim\Routing\RouteContext;

class GetArticleCompletApiAction
{
    private ArticleManagementService $articleManagementService;

    public function __construct()
    {
        $this->articleManagementService = new ArticleManagementService();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $id = (int) $args['id'];
        try {
            $articles = $this->articleManagementService->getArticleById($id);
        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($rq, "Erreur lors de la récupération de l'article.");
        }

        $routeParser = RouteContext::fromRequest($rq)->getRouteParser();


        $rs->getBody()->write(json_encode($articles));
        return $rs->withHeader('Content-Type', 'application/json');
    }
}