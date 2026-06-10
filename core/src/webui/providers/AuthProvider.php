<?php
declare(strict_types=1);
namespace  minipress\core\webui\providers;

use minipress\core\application_core\application\usecases\AuthnService;

class AuthProvider implements AuthProviderInterface
{
    private AuthnService $authnService;

    public function __construct()
    {
        $this->authnService = new AuthnService();
    }

    public function signin(string $email, string $password): void
    {
        $user = $this->authnService->byCredentials($email, $password);
        $_SESSION['user'] = ['id' => $user->id, 'email' => $user->user_id, 'role' => $user->role];
    }

    public function getSignedInUser(): ?array
    {
        return $_SESSION['user'] ?? null;
    }
}