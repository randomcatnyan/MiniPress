<?php
namespace minipress\core\application_core\application\usecases;

interface GestionCategorieInterface 
{
    public function creerCategorie(array $data): int;
}