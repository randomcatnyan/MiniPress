<?php

namespace minipress\core\webui\providers;

use Exception;

class CsrfTokenProvider
{
    public function generate(): string
    {
        $token = bin2hex(random_bytes(32));
        $_SESSION['csrf_token'] = $token;
        return $token;
    }

    public function check(string $tokenRecu): void
    {
        $tokenEnSession = $_SESSION['csrf_token'] ?? null;

        if ($tokenEnSession !== $tokenRecu) {
            throw new Exception("errueur token");
        }
        unset($_SESSION['csrf_token']);
    }
}
