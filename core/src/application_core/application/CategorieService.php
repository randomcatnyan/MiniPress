<?php

declare(strict_types=1);

namespace minipress\core\application_core\application;

use minipress\core\application_core\domain\Categorie;

class CategorieService
{
    public function creerCategorie(string $titre, string $description): Categorie
    {
        $categorie = new Categorie();
        $categorie->titre = $titre;
        $categorie->description = $description;
        $categorie->save();

        return $categorie;
    }
}
