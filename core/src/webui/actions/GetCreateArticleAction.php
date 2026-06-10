<?php
declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Slim\Views\Twig;
use minipress\core\application_core\application\usecases\CategorieService;
use minipress\core\webui\providers\CsrfTokenProvider;

class GetCreateArticleAction extends AbstractAction
{
    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $view  = Twig::fromRequest($rq);
        $token = (new CsrfTokenProvider())->generate();
        $categories = (new CategorieService())->getCategorie();
        return $view->render($rs, 'CreateArticleForm.twig', ['csrf' => $token, 'categories' => $categories]);
    }
}