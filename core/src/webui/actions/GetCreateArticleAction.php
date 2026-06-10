<?php
declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Slim\Views\Twig;
use minipress\core\application_core\application\usecases\CategorieService;
use minipress\core\webui\providers\CsrfTokenProvider;
use minipress\core\webui\providers\AuthProvider;
use Slim\Exception\HttpForbiddenException;

class GetCreateArticleAction extends AbstractAction
{
    private AuthProvider $authProvider;

    public function __construct()
    {
        $this->authProvider = new AuthProvider();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $user = $this->authProvider->getSignedInUser();
        if (!$user) {
            throw new HttpForbiddenException($rq, "Vous devez être connecté pour créer un article.");
        }
        $view  = Twig::fromRequest($rq);
        $token = (new CsrfTokenProvider())->generate();
        $categories = (new CategorieService())->getCategorie();
        return $view->render($rs, 'CreateArticleForm.twig', ['csrf' => $token, 'categories' => $categories]);
    }
}