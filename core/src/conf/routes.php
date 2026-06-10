<?php

declare(strict_types=1);

use minipress\core\webui\actions\GetCreateCategorieAction;
use minipress\core\webui\actions\PostCreateCategorieAction;
use minipress\core\actions\ShowLoginFormAction;
use minipress\core\actions\AuthenticateAction;
use minipress\core\actions\LogoutAction;
use Slim\App;


return function (App $app): App {
    $app->get('categories/create', GetCreateCategorieAction::class)->setName('cate_cree_get');
    $app->post('categories/create', PostCreateCategorieAction::class)->setName('cate_cree_post');
    $app->get('/login', ShowLoginFormAction::class)->setName('login');
    $app->post('/login', AuthenticateAction::class)->setName('login.post');
    $app->get('/logout', LogoutAction::class)->setName('logout');

    return $app;
};


