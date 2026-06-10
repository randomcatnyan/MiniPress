<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;
use minipress\core\application_core\application\usecases\ArticleManagementService;
use minipress\core\webui\providers\AuthProvider;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;
use Slim\Routing\RouteContext;
use Slim\Views\Twig;

class getArticleByCategorieAction extends AbstractAction {

    private ArticleManagementService $articleManagementService;
    private AuthProvider $authProvider;

    public function __construct()
    {
        $this->articleManagementService = new ArticleManagementService();
        $this->authProvider = new AuthProvider();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $id = (int)$args['id'];
        try {
            $articles = $this->articleManagementService->getArticleByCategorie($id);
        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($rq, "Erreur lors de la récupération des articles : " . $e->getMessage());
        }

        $routescontexte = RouteContext::fromRequest($rq);
        $routeParser = $routescontexte->getRouteParser();
        $view = Twig::fromRequest($rq);
        return $view->render($rs, 'ArticleByCategorie.twig', ['articles' => $articles]);
    }

}