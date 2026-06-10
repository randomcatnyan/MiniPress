<?php
declare(strict_types=1);
namespace minipress\core\webui\providers;

interface AuthProviderInterface
{
    public function signin(string $email, string $password): void;
    public function getSignedInUser(): ?array;
}