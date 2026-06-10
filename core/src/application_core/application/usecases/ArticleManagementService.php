<?php

namespace minipress\core\application_core\application\usecases;

use minipress\core\application_core\domain\entities\Article;
use Illuminate\Database\QueryException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use minipress\core\application_core\domain\Exception\ArticleException;

class ArticleManagementService implements ArticleManagementInterface
{
    public function creerArticle(array $data): string
    {

        if (empty($data['titre']) || empty($data['contenu'])) {
            throw new \InvalidArgumentException('Le titre et le contenu sont requis.');
        }

        $article = new Article();
        $article->titre = $data['titre'];
        $article->resume = $data['resume'] ?? null;
        $article->contenu = $data['contenu'];
        $article->categorie_id = $data['categorie_id'] ?? null;
        $article->auteur_id = $data['auteur_id'];
        $article->est_publie = 0;

        $article->save();

        return (string) $article->id;
    }

    public function getArticle(): array
    {
        try {
            return Article::with('auteur')->orderBy('cree', 'desc')->get()->toArray();
        } catch (QueryException $e) {
            throw new ArticleException("Erreur lors de la récupération des articles.");
        }
    }

    public function getArticleByCategorie(int $categorieId): array
    {
        try {
            return Article::with('auteur')->where('categorie_id', $categorieId)->orderBy('cree', 'desc')->get()->toArray();
        } catch (ModelNotFoundException $e) {
            throw new ArticleException("L'article avec l'ID $categorieId est introuvable.", 404);
        } catch (QueryException $e) {
            throw new ArticleException("Erreur de base de données.");
        }
    }
}
