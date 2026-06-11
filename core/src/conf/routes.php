<?php

declare(strict_types=1);

use minipress\core\webui\actions\GetCreateCategorieAction;
use minipress\core\webui\actions\PostCreateCategorieAction;
use minipress\core\webui\actions\LogoutAction;
use minipress\core\webui\actions\SigninAction;
use minipress\core\webui\actions\CreateArticleAction;
use minipress\core\webui\actions\GetArticleAction;
use minipress\core\webui\actions\GetArticleByCategorieAction;
use minipress\core\webui\actions\GetCreateArticleAction;
use minipress\core\webui\actions\GetCategorieAction;
use minipress\core\webui\actions\GetCreeUserAction;
use minipress\core\webui\actions\PostCreeUserAction;


use Slim\App;
use minipress\core\webui\actions\GetHomeAction;


return function (App $app): App {
    $app->get('/home', GetHomeAction::class)->setName('home');
    
    $app->get('/signin',  SigninAction::class)->setName('signin');       
    $app->post('/signin', SigninAction::class)->setName('signin_post');  
    $app->get('/logout',  LogoutAction::class)->setName('logout');

    $app->get('/categories/create', GetCreateCategorieAction::class)->setName('cate_cree_get');
    $app->post('/categories/create', PostCreateCategorieAction::class)->setName('cate_cree_post');
    $app->get('/categories', GetCategorieAction::class)->setName('categories');

    $app->get('/articles', GetArticleAction::class)->setName('articles');                          
    $app->get('/articles/create',  GetCreateArticleAction::class)->setName('create_article');       
    $app->post('/articles/create', CreateArticleAction::class)->setName('create_article_post');     
    $app->get('/categories/{id}/articles', GetArticleByCategorieAction::class)->setName('articles_by_cat'); 

    $app->get('/cree/user',  GetCreeUserAction::class)->setName('cree_user_get');
    $app->post('/cree/user', PostCreeUserAction::class)->setName('cree_user_post');


    return $app;
};
