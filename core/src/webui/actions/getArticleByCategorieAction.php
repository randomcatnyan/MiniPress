<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;
use minipress\core\application_core\application\usecases\ArticleManagementService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;
use minipress\core\application_core\application\usecases\CategorieService;
use Slim\Views\Twig;

class getArticleByCategorieAction extends AbstractAction {

    private ArticleManagementService $articleManagementService;
    private CategorieService $categorieService;

    public function __construct()
    {
        $this->articleManagementService = new ArticleManagementService();
        $this->categorieService = new CategorieService();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $id = (int)$args['id'];
        try {
            $articles = $this->articleManagementService->getArticleByCategorie($id);
            $categorie = $this->categorieService->getCategorieById($id);

        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($rq, "Erreur lors de la récupération des articles : " . $e->getMessage());
        }

        $view = Twig::fromRequest($rq);
        return $view->render($rs, 'ArticleByCategorie.twig', ['articles' => $articles, 'categorie' => $categorie]);
    }

}