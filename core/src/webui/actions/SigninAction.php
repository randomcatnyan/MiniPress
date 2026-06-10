<?php
declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Slim\Exception\HttpBadRequestException;
use Slim\Exception\HttpForbiddenException;
use Slim\Exception\HttpInternalServerErrorException;
use Slim\Views\Twig;
use minipress\core\webui\providers\AuthProvider;
use minipress\core\webui\providers\CsrfTokenProvider;

class SigninAction extends AbstractAction
{
    private AuthProvider $authProvider;

    public function __construct()
    {
        $this->authProvider = new AuthProvider();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        if ($rq->getMethod() === 'GET') {
            $view  = Twig::fromRequest($rq);
            $token = (new CsrfTokenProvider())->generate();
            return $view->render($rs, 'signin.twig', [
                'csrf' => $token,
            ]);
        }

        $data = $rq->getParsedBody() ?? [];

        $csrfToken = $data['csrf_token'] ?? '';
        try {
            (new CsrfTokenProvider())->check($csrfToken);
        } catch (\Exception $e) {
            throw new HttpForbiddenException($rq, "Erreur de sécurité CSRF : " . $e->getMessage());
        }

        $email    = filter_var($data['email'] ?? '', FILTER_VALIDATE_EMAIL);
        $password = $data['password'] ?? '';
        if (!$email || !$password) {
            throw new HttpBadRequestException($rq, "Email ou mot de passe manquant.");
        }

        try {
            $this->authProvider->signin($email, $password);
            return $rs->withHeader('Location', '/home')->withStatus(302);
        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($rq, "Erreur lors de l'authentification : " . $e->getMessage());
        }
    }
}