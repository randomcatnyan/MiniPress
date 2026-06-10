<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;
use minipress\core\application_core\application\usecases\CategorieService;
use Slim\Views\Twig;

class GetCategorieAction extends AbstractAction {

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
            throw new HttpInternalServerErrorException($rq, "Erreur lors de la récupération des catégories : " . $e->getMessage());
        }
        $view = Twig::fromRequest($rq);
        return $view->render($rs, 'Categorie.twig', ['categories' => $categories]);
    }

}