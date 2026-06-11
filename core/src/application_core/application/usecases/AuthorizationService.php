<?php

namespace minipress\core\application_core\application\usecases;

class AuthorizationService implements AuthorizationInterface
{
    public function isGranted(array $user_profile, string $operation, $ressource_id = null): bool
    {
        switch ($operation) {
            case self::OPERATION_CREER_UTILISATEUR:
                return $this->isAdmin($user_profile);

            default:
                return false;
        }
    }

    public function isAdmin(array $user_profile): bool
    {
        $role = $user_profile['role'] ?? null;
        return $role === 'admin';
    }
}