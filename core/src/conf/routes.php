<?php

declare(strict_types=1);

use minipress\core\webui\actions\GetCreateCategorieAction;
use minipress\core\webui\actions\PostCreateCategorieAction;
use minipress\core\actions\LogoutAction;
use minipress\core\webui\actions\SigninAction;
use minipress\core\webui\actions\CreateArticleAction;
use minipress\core\webui\actions\getArticleAction;
use minipress\core\webui\actions\getArticleByCategorieAction;
use minipress\core\webui\actions\GetCreateArticleAction;


use Slim\App;
use minipress\core\webui\actions\GetHomeAction;


return function (App $app): App {
    $app->get('/home', GetHomeAction::class)->setName('home');
    
    $app->get('/signin',  SigninAction::class)->setName('signin');       
    $app->post('/signin', SigninAction::class)->setName('signin_post');  
    $app->get('/logout',  LogoutAction::class)->setName('logout');

    $app->get('/categories/create', GetCreateCategorieAction::class)->setName('cate_cree_get');
    $app->post('/categories/create', PostCreateCategorieAction::class)->setName('cate_cree_post');

    $app->get('/articles', getArticleAction::class)->setName('articles');                          
    $app->get('/articles/create',  GetCreateArticleAction::class)->setName('create_article');       
    $app->post('/articles/create', CreateArticleAction::class)->setName('create_article_post');     
    $app->get('/categories/{id}/articles', getArticleByCategorieAction::class)->setName('articles_by_cat'); 


    return $app;
};
