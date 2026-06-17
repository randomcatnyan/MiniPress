<?php
namespace minipress\core\webui\actions;

use minipress\core\application_core\application\usecases\ArticleManagementService;
use minipress\core\webui\providers\AuthProvider;
use minipress\core\webui\providers\CsrfTokenProvider;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpForbiddenException;
use Slim\Exception\HttpInternalServerErrorException;

class CreateArticleAction extends AbstractAction
{
    private ArticleManagementService $articleManagementService;
    private AuthProvider $authProvider;

    public function __construct()
    {
        $this->articleManagementService = new ArticleManagementService();
        $this->authProvider = new AuthProvider();
    }

    public function __invoke(Request $rq, Response $rs, array $args): Response
    {
        $data = $rq->getParsedBody() ?? [];

        $csrfToken = $data['csrf_token'] ?? '';
        try {
            (new CsrfTokenProvider())->check($csrfToken);
        } catch (\Exception $e) {
            throw new HttpForbiddenException($rq, "Erreur de sécurité CSRF : " . $e->getMessage());
        }

        $user = $this->authProvider->getSignedInUser();
        if (!$user) {
            throw new HttpForbiddenException($rq, "Vous devez être connecté pour créer un article.");
        }
        $userId = $this->authProvider->getSignedInUser()['id'] ?? null;

        $titre = filter_var($data['titre']   ?? '', FILTER_SANITIZE_SPECIAL_CHARS);
        $resume = $data['resume']  ?? '';
        $contenu = $data['contenu'] ?? '';
        $categorieId = $data['categorie_id'] ?: null;
        $imageUrl = filter_var($data['image_url'] ?? '', FILTER_SANITIZE_URL) ?: null;


        try {
            $this->articleManagementService->creerArticle([
                'titre' => $titre,
                'resume' => $resume,
                'contenu' => $contenu,
                'auteur_id' => $userId,
                'categorie_id' => $categorieId,
                'image_url' => $imageUrl,
            ]);

            return $rs->withHeader('Location', '/articles')->withStatus(302);
        } catch (\Exception $e) {
            throw new HttpInternalServerErrorException($rq, "Erreur lors de la création de l'article : " . $e->getMessage());
        }
    }
}