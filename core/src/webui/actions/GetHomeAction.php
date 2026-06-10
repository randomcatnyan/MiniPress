<?php
declare(strict_types=1);


namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Slim\Views\Twig;

class GetHomeAction extends AbstractAction {
    public function __invoke(Request $rq, Response $rs, array $args): Response {

        $view = Twig::fromRequest($rq);
        return $view->render($rs, 'home.twig');
        
    }
}