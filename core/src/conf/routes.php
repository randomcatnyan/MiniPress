<?php

declare(strict_types=1);

use minipress\core\webui\actions\GetCreateCategorieAction;
use minipress\core\webui\actions\PostCreateCategorieAction;
use Slim\App;
use minipress\core\actions\LoginAction;


return function (App $app): App {
    $login = new LoginAction();


    $app->get('categories/create', GetCreateCategorieAction::class)->setName('cate_cree_get');
    $app->post('categories/create', PostCreateCategorieAction::class)->setName('cate_cree_post');
    $app->get('/login', [$login, 'showForm'])->setName('login');
    $app->post('/login', [$login, 'authenticate'])->setName('login.post');
    $app->get('/logout', [$login, 'logout'])->setName('logout');

    return $app;
};

