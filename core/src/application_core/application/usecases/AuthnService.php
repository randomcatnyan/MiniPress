<?php

namespace minipress\core\application_core\application\usecases;

use minipress\core\application_core\domain\entities\Utilisateur;

class AuthnService implements AuthnInterface
{

    public function registerUser(string $email, string $password): void
    {
        try{

            $email = filter_var($email, FILTER_VALIDATE_EMAIL);
            if (!$email) {
                throw new \InvalidArgumentException("Email invalide.");
            }
            
            if (Utilisateur::where('email', $email)->exists()) {
                throw new \InvalidArgumentException("Un utilisateur avec cet email existe déjà.");
            }
            
            $user = new Utilisateur();
            $mdp = password_hash($password, PASSWORD_BCRYPT);
            $user->email = $email;
            $user->mdp = $mdp;
            $user->role = Utilisateur::ROLE_USER;
            $user->save();   

        }catch(\Exception $e){
            throw new \InvalidArgumentException("Erreur lors de l'enregistrement de l'utilisateur : " . $e->getMessage());
        }
    }

    public function byCredentials(string $email, string $password): Utilisateur
    {
        try {
            $user = Utilisateur::where('email', $email)->firstOrFail();

            if (!password_verify($password, $user->mdp)) {
                throw new \InvalidArgumentException("Email ou mot de passe incorrect.");
            }

            return $user;

        } catch (\Exception $e) {
            throw new \InvalidArgumentException("Erreur lors de la vérification des credentials : " . $e->getMessage());
        }
    }

}
