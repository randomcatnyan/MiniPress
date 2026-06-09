<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;

use minipress\core\application_core\application\CategorieService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Views\Twig;

class PostCreateCategorieAction
{
    public function __invoke(Request $request, Response $response, array $args): Response
    {
        $view = Twig::fromRequest($request);
        $data = $request->getParsedBody();


        $titre = filter_var($data['titre'] ?? '', FILTER_SANITIZE_SPECIAL_CHARS);
        $description = filter_var($data['description'] ?? '', FILTER_SANITIZE_SPECIAL_CHARS);


        if (empty(trim($titre))) {
            return $view->render($response, 'create_categorie.twig', [
                'error' => 'Le titre de la catégorie est obligatoire.',
                'message' => null,
                'old' => ['titre' => $titre, 'description' => $description],
            ]);
        }

        try {
            $service = new CategorieService();
            $service->creerCategorie($titre, $description);

            return $view->render($response, 'create_categorie.twig', [
                'message' => 'Catégorie créée avec succès !',
                'error' => null,
                'old' => null,
            ]);
        } catch (\Exception $e) {
            return $view->render($response, 'create_categorie.twig', [
                'error' => 'Erreur lors de la création de la catégorie : ' . $e->getMessage(),
                'message' => null,
                'old' => ['titre' => $titre, 'description' => $description],
            ]);
        }
    }
}
