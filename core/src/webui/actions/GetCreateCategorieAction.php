<?php
declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use minipress\core\webui\providers\CsrfTokenProvider;
use Slim\Views\Twig;

class GetCreateCategorieAction
{
    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $token = (new CsrfTokenProvider())->generate();
        
        $view = Twig::fromRequest($rq);
        return $view->render($rs, 'cree_cate.twig', [
            'csrf' => $token
        ]);
    }
}