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
        try {
            $articles = $this->articleManagementService->getArticle();
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
                    'cree' => $article['cree'],
                    'auteur' => $article['auteur']['nom'] ?? null,
                    'lien' => $routeParser->urlFor('api_article_complet', ['id' => $article['id']])
                    
                ];
            }

        $rs->getBody()->write(json_encode($tab));
        return $rs->withHeader('Content-Type', 'application/json');
    }
}