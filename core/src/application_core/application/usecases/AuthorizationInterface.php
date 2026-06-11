<?php

namespace minipress\core\application_core\application\usecases;

interface AuthorizationInterface
{
    public const OPERATION_CREER_UTILISATEUR = 'cree_utilisateur';

    public function isGranted(array $user_profile, string $operation): bool;
}