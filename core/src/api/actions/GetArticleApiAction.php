<?php

declare(strict_types=1);

namespace minipress\core\api\actions;

use minipress\core\application_core\application\usecases\ArticleManagementService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;
use Slim\Routing\RouteContext;

class GetArticleApiAction
{
    private ArticleManagementService $articleManagementService;

    public function __construct()
    {
        $this->articleManagementService = new ArticleManagementService();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $paramSort = $rq->getQueryParams();
        $sort = $paramSort['sort'] ?? null;

        try {
            $articles = $this->articleManagementService->getArticleSorted($sort);
        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($rq, "Erreur lors de la récupération des articles.");
        }

        $routeParser = RouteContext::fromRequest($rq)->getRouteParser();


        $tab = [];
        foreach ($articles as $article) {
            if ((int)$article['est_publie'] !== 1) {
                continue;
            }
            $tab[] = [
                'titre' => $article['titre'],
                'resume' => $article['resume'] ?? '',
                'cree' => $article['cree'],
                'auteur' => [
                    'nom' => $article['auteur']['nom'] ?? null,
                    'id' => $article['auteur_id'] ?? null
                ],
                'lien' => $routeParser->urlFor('api_article_complet', ['id' => $article['id']])

            ];
        }

        $rs->getBody()->write(json_encode($tab));
        return $rs->withHeader('Content-Type', 'application/json');
    }
}
