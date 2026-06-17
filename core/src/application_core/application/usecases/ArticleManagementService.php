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
        $article->image_url = $data['image_url'] ?? null;
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

    public function getArticleSorted(?string $sort = null): array
    {
        try {
            $query = Article::with('auteur');

            switch ($sort) {
            case 'date-asc':
                $query->orderBy('cree', 'asc');
                break;
            case 'date-desc':
                $query->orderBy('cree', 'desc');
                break;
            case 'auteur':
                $query->orderBy('auteur_id', 'asc');
                break;
            default:
                $query->orderBy('cree', 'desc');
        }
            return $query->get()->toArray();
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

    public function getArticleByAuteur(int $id): array
    {
        try{
            return Article::with('auteur')->where('auteur_id', $id)->orderBy('cree', 'desc')->get()->toArray();
        } catch (ModelNotFoundException $e) {
            throw new ArticleException("L'article avec l'ID $id est introuvable.", 404);
        } catch (QueryException $e) {
            throw new ArticleException("Erreur de base de données.");
        }
    }

    public function getArticleById(int $id): array
    {
        try {
            $article = Article::with('auteur')->findOrFail($id);
            return $article->toArray();
        } catch (ModelNotFoundException $e) {
            throw new ArticleException("L'article avec l'ID $id est introuvable.", 404);
        } catch (QueryException $e) {
            throw new ArticleException("Erreur de base de données.");
        }
    }

    public function publier(int $id): void
    {
        try {
            $article = Article::findOrFail($id);
            $article->est_publie = $article->est_publie ? 0 : 1;
            $article->save();
        } catch (\Exception $e) {
            throw new ArticleException("erreur bdd " . $e->getMessage());
        }
    }
}
