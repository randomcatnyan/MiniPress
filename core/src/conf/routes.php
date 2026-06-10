<?php

declare(strict_types=1);

use minipress\core\actions\LoginAction;
use Slim\App;

return function (App $app): App {

    $login = new LoginAction();

    $app->get('/login', [$login, 'showForm'])->setName('login');
    $app->post('/login', [$login, 'authenticate'])->setName('login.post');
    $app->get('/logout', [$login, 'logout'])->setName('logout');

    return $app;
};
