<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use minipress\core\application_core\application\usecases\AuthnService;
use minipress\core\application_core\application\usecases\AuthorizationService;
use minipress\core\application_core\application\usecases\AuthorizationInterface;
use minipress\core\webui\providers\CsrfTokenProvider;
use minipress\core\webui\providers\AuthProvider;
use Slim\Exception\HttpForbiddenException;
use Slim\Exception\HttpInternalServerErrorException;
use Slim\Views\Twig;
use InvalidArgumentException;

class PostCreeUserAction
{
    private AuthnService $authnService;
    private AuthProvider $authProvider;
    private AuthorizationService $authService;

    public function __construct()
    {
        $this->authnService = new AuthnService();
        $this->authProvider = new AuthProvider();
        $this->authService = new AuthorizationService();
    }

    public function __invoke(Request $request, Response $response, array $args): Response
    {
        $data = $request->getParsedBody() ?? [];
        $view = Twig::fromRequest($request);
        $csrfToken = $data['csrf_token'] ?? '';
        try {
            (new CsrfTokenProvider())->check($csrfToken);
        } catch (\Exception $e) {
            throw new HttpForbiddenException($request, "erreur csrf " . $e->getMessage());
        }
        $user = $this->authProvider->getSignedInUser();
        if (!$user || !$this->authService->isGranted($user, AuthorizationInterface::OPERATION_CREER_UTILISATEUR)) {
            throw new HttpForbiddenException($request, "pas les perms");
        }
        $nom = filter_var($data['nom'] ?? '', FILTER_SANITIZE_SPECIAL_CHARS);
        $email = filter_var($data['email'] ?? '', FILTER_SANITIZE_EMAIL);
        $password = $data['mdp'] ?? '';

        try {
            $this->authnService->registerUser($email, $password,$nom);
            return $view->render($response, 'home.twig', [
                'csrf' => (new CsrfTokenProvider())->generate(),
                'user' => $user
            ]);

        } catch (InvalidArgumentException $e) {
            return $view->render($response, 'cree_utilisateur.twig', [
                'csrf' => (new CsrfTokenProvider())->generate(),
                'user' => $user
            ]);
        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($request, "erreurs bdd pr enregistrer " . $e->getMessage());
        }
    }
}