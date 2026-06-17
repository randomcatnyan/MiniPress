<?php

declare(strict_types=1);

namespace minipress\core\application_core\application\usecases;

use minipress\core\application_core\domain\entities\Categorie;
use minipress\core\application_core\domain\Exception\CategorieException;
use Illuminate\Database\QueryException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
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
            throw new CategorieException("Erreur SQL : " . $e->getMessage());
        }
    }

    public function getCategorie(): array
    {
        try {
            return Categorie::all()->toArray();
        } catch (QueryException $e) {
            throw new CategorieException("Erreur lors de la récupération des catégories." . $e->getMessage());
        }
    }

    public function getCategorieById(int $id): array
    {
        try {
            $categorie = Categorie::findOrFail($id);
            return $categorie->toArray();
        } catch (QueryException $e) {
            throw new CategorieException("Erreur lors de la récupération de la catégorie." . $e->getMessage());
        } catch (ModelNotFoundException $e) {
            throw new CategorieException("La catégorie avec l'ID $id est introuvable.", 404);
        }
    }
}

