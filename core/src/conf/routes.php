<?php
declare(strict_types=1);

use minipress\core\webui\actions\GetCreateCategorieAction;
use minipress\core\webui\actions\PostCreateCategorieAction;
use Slim\App;

return function (App $app): App {
    $app->get('/admin/categories/create', GetCreateCategorieAction::class)->setName('cate_cree_get');
    $app->post('/admin/categories/create', PostCreateCategorieAction::class)->setName('cate_cree_post');

    return $app;
};