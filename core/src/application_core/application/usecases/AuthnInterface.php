<?php

namespace minipress\core\application_core\application\usecases;
use minipress\core\application_core\domain\entities\Utilisateur;

interface AuthnInterface
{
    public function registerUser(string $email, string $password, string $nom): void;
    public function byCredentials(string $email, string $password): Utilisateur;
}