<?php
declare(strict_types=1);

namespace minipress\core\api\actions;

use minipress\core\application_core\application\usecases\CategorieService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;

class GetCategoriesApiAction
{
    private CategorieService $categorieService;

    public function __construct()
    {
        $this->categorieService = new CategorieService();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        try {
            $categories = $this->categorieService->getCategorie();
        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($rq, "Erreur lors de la récupération des catégories.");
        }

        $rs->getBody()->write(json_encode($categories));
        return $rs->withHeader('Content-Type', 'application/json');
    }
}