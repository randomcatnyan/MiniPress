<?php
namespace minipress\core\application_core\application\usecases;

interface CategorieInterface 
{
    public function creerCategorie(array $data): int;
    public function getCategorie(): array;
    public function getCategorieById(int $id): array;
}