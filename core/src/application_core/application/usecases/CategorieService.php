<?php

declare(strict_types=1);

namespace minipress\core\application_core\application\usecases;

use minipress\core\application_core\domain\entities\Categorie;
use minipress\core\application_core\domain\Exception\CategorieException;
use Illuminate\Database\QueryException;
use InvalidArgumentException;

class CategorieService implements CategorieInterface
{
    public function creerCategorie(array $data): int
    {
        if (empty($data['titre'])) {
            throw new InvalidArgumentException("titre obligatoire");
        }
        try {
            $categorie = new Categorie();
            $categorie->titre = $data['titre'];
            $categorie->description = $data['description'] ?? null;
            $categorie->save();
            return $categorie->id;
        } catch (QueryException $e) {
            throw new CategorieException("Erreur SQL Brute : " . $e->getMessage());
        }
    }
}
