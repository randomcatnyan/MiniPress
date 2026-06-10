<?php

declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use minipress\core\application_core\application\usecases\CategorieService;
use minipress\core\webui\providers\CsrfTokenProvider;
use Slim\Exception\HttpForbiddenException;
use Slim\Exception\HttpInternalServerErrorException;
use Slim\Views\Twig;

class PostCreateCategorieAction
{
    private CategorieService $categorieService;

    public function __construct()
    {
        $this->categorieService = new CategorieService();
    }

    public function __invoke(Request $request, Response $response, array $args): Response
    {
        $data = $request->getParsedBody() ?? [];
        $csrfToken = $data['csrf_token'] ?? '';
        try {
            (new CsrfTokenProvider())->check($csrfToken);
        } catch (\Exception $e) {
            throw new HttpForbiddenException($request, "rereur csrf : " . $e->getMessage());
        }
        $titre = filter_var($data['titre'] ?? '', FILTER_SANITIZE_SPECIAL_CHARS);
        $description = filter_var($data['description'] ?? '', FILTER_SANITIZE_SPECIAL_CHARS);

        try {
            $this->categorieService->creerCategorie([
                'titre' => $titre,
                'description' => $description
            ]);
            $token = (new CsrfTokenProvider())->generate();
            $view = Twig::fromRequest($request);

            return $view->render($response, 'cree_cate.twig', [
                'csrf' => $token
            ]);

        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($request, "erreur creation " . $e->getMessage());
        }
    }
}