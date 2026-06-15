<?php
declare(strict_types=1);

namespace minipress\core\api\actions;

use minipress\core\application_core\application\usecases\ArticleManagementService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;
use Slim\Routing\RouteContext;

class GetArticleByAuteurApiAction
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
            $articles = $this->articleManagementService->getArticleByAuteur($id);
        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($rq, "Erreur lors de la récupération des articles.");
        }

        $routeParser = RouteContext::fromRequest($rq)->getRouteParser();


        $tab = [];
            foreach ($articles as $article) {
                $tab[] = [
                    'titre' => $article['titre'],
                    'cree' => $article['cree'],
                    'auteur' => [
                        'nom' => $article['auteur']['nom'] ?? null,
                        'id' => $article['auteur_id'] ?? null
                    ],

                    'lien' => $routeParser->urlFor('api_article_complet', ['id' => $article['id']])
                    
                ];
            }
           
        $data = [
            'Auteur' => [
                'id' => $id,
                'nom' => $articles[0]['auteur']['nom'] ?? null,
            ],
            'articles' => $tab
        ];    

        $rs->getBody()->write(json_encode($data));
        return $rs->withHeader('Content-Type', 'application/json');
    }
}