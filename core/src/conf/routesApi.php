<?php

declare(strict_types=1);


use minipress\core\api\actions\GetCategoriesApiAction;
use minipress\core\api\actions\GetArticleApiAction;
use minipress\core\api\actions\GetArticleCompletApiAction;
use minipress\core\api\actions\GetArticleByCategorieApiAction;
use minipress\core\api\actions\GetArticleByAuteurApiAction;
use Slim\App;


return function (App $app): App {
    $app->get('/api/categories', GetCategoriesApiAction::class)->setName('api_categories');
    $app->get('/api/articles', GetArticleApiAction::class)->setName('api_articles');
    $app->get('/api/articles/{id}', GetArticleCompletApiAction::class)->setName('api_article_complet');
    $app->get('/api/categories/{id}/articles', GetArticleByCategorieApiAction::class)->setName('api_articles_by_cat');
    $app->get('/api/auteurs/{id}/articles', GetArticleByAuteurApiAction::class)->setName('api_articles_by_auteur');

    return $app;
};
