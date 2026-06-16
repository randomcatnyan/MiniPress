<?php
declare(strict_types=1);

namespace minipress\core\api\actions;

use minipress\core\application_core\application\usecases\ArticleManagementService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;
use Slim\Routing\RouteContext;
use minipress\core\application_core\application\usecases\CategorieService;

class GetArticleByCategorieApiAction
{
    private ArticleManagementService $articleManagementService;
    private CategorieService $categorieService;

    public function __construct()
    {
        $this->articleManagementService = new ArticleManagementService();
        $this->categorieService = new CategorieService();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $id = (int) $args['id'];
        try {
            $articles = $this->articleManagementService->getArticleByCategorie($id);
            $categorie = $this->categorieService->getCategorieById($id);
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
                    'auteur' => [
                        'nom' => $article['auteur']['nom'] ?? null,
                        'id' => $article['auteur_id'] ?? null
                    ],
                    'lien' => $routeParser->urlFor('api_article_complet', ['id' => $article['id']])
                    
                ];
            }
           
        $data = [
            'categorie' => [
                'id' => $categorie['id'],
                'titre' => $categorie['titre'],
            ],
            'articles' => $tab
        ];    

        $rs->getBody()->write(json_encode($data));
        return $rs->withHeader('Content-Type', 'application/json');
    }
}