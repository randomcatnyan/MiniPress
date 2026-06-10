<?php
declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use minipress\core\webui\providers\CsrfTokenProvider;
use Slim\Exception\HttpForbiddenException;
use minipress\core\webui\providers\AuthProvider;   
use Slim\Views\Twig;

class GetCreateCategorieAction
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
            throw new HttpForbiddenException($rq, "connecte toi pour voir cette page");
        }
        $token = (new CsrfTokenProvider())->generate();
        
        $view = Twig::fromRequest($rq);
        return $view->render($rs, 'cree_cate.twig', [
            'csrf' => $token
        ]);
    }
}