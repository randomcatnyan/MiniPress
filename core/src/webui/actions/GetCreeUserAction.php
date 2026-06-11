<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use minipress\core\webui\providers\CsrfTokenProvider;
use minipress\core\webui\providers\AuthProvider;
use minipress\core\application_core\application\usecases\AuthorizationService;
use minipress\core\application_core\application\usecases\AuthorizationInterface;
use Slim\Exception\HttpForbiddenException;
use Slim\Views\Twig;

class GetCreeUserAction
{
    private AuthProvider $authProvider;
    private AuthorizationService $authService;

    public function __construct()
    {
        $this->authProvider = new AuthProvider();
        $this->authService = new AuthorizationService();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $user = $this->authProvider->getSignedInUser();
        if (!$user) {
            throw new HttpForbiddenException($rq, "connecte toi");
        }
        if (!$this->authService->isGranted($user, AuthorizationInterface::OPERATION_CREER_UTILISATEUR)) {
            throw new HttpForbiddenException($rq, "pas la permission");
        }
        $token = (new CsrfTokenProvider())->generate();
        $view = Twig::fromRequest($rq);

        return $view->render($rs, 'cree_utilisateur.twig', [
            'csrf' => $token,
            'user' => $user
        ]);
    }
}