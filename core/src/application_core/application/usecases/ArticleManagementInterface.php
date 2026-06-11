<?php
namespace minipress\core\application_core\application\usecases;

interface ArticleManagementInterface
{
    public function creerArticle(array $data): string;
    public function getArticle(): array;
    public function getArticleSorted(?string $sort = null): array;
    public function getArticleByCategorie(int $categorieId): array;
    public function getArticleById(int $id): array;

}