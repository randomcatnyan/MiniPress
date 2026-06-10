<?php

declare(strict_types=1);

namespace minipress\core\actions;

use minipress\core\models\Utilisateur;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Views\Twig;

class LoginAction
{
    public function showForm(Request $request, Response $response): Response
    {
        $view = Twig::fromRequest($request);
        return $view->render($response, 'login.twig');
    }

    public function authenticate(Request $request, Response $response): Response
    {
        $view = Twig::fromRequest($request);
        $data = $request->getParsedBody();

        $email = trim($data['email'] ?? '');
        $mdp = $data['mdp'] ?? '';

        $errors = [];

        if (empty($email)) {
            $errors[] = 'L\'adresse email est requise.';
        }
        if (empty($mdp)) {
            $errors[] = 'Le mot de passe est requis.';
        }

        if (!empty($errors)) {
            return $view->render($response, 'login.twig', [
                'errors' => $errors,
                'email' => $email
            ]);
        }

        $utilisateur = Utilisateur::where('email', $email)->first();

        if (!$utilisateur || !password_verify($mdp, $utilisateur->mdp)) {
            return $view->render($response, 'login.twig', [
                'errors' => ['Email ou mot de passe incorrect.'],
                'email' => $email
            ]);
        }

        $_SESSION['user'] = [
            'id' => $utilisateur->id,
            'nom' => $utilisateur->nom,
            'email' => $utilisateur->email
        ];

        return $response
            ->withHeader('Location', '/articles/create')
            ->withStatus(302);
    }

    public function logout(Request $request, Response $response): Response
    {
        unset($_SESSION['user']);
        session_destroy();

        return $response
            ->withHeader('Location', '/login')
            ->withStatus(302);
    }
}
