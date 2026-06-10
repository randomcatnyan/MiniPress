<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;

use minipress\core\application_core\application\usecases\ArticleManagementService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;
use Slim\Views\Twig;

class getArticleAction extends AbstractAction {

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
            throw new HttpInternalServerErrorException($rq, "Erreur lors de la récupération des articles : " . $e->getMessage());
        }

        $view = Twig::fromRequest($rq);
        return $view->render($rs, 'Article.twig', ['articles' => $articles]);
    }

}