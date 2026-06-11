<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use minipress\core\application_core\application\usecases\ArticleManagementService;
use minipress\core\webui\providers\AuthProvider;
use Slim\Exception\HttpForbiddenException;

class PublierAction extends AbstractAction
{
    private ArticleManagementService $articleService;
    private AuthProvider $authProvider;

    public function __construct()
    {
        $this->articleService = new ArticleManagementService();
        $this->authProvider = new AuthProvider();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $user = $this->authProvider->getSignedInUser();
        if (!$user) {
            throw new HttpForbiddenException($rq, "connecte toi");
        }
        $id = (int) $args['id'];
        $article = $this->articleService->getArticleById($id);
        if ((int)$user['id'] !== (int)$article['auteur_id']) {
            throw new HttpForbiddenException($rq, "tu dois etre le proprio de l article");
        }
        $this->articleService->publier($id);
        return $rs->withHeader('Location', '/articles')->withStatus(302);
    }
}