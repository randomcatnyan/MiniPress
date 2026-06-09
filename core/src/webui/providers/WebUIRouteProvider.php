<?php

declare(strict_types=1);

namespace minipress\core\webui\providers;

use minipress\core\webui\actions\GetFormCreateCategorieAction;
use minipress\core\webui\actions\PostCreateCategorieAction;
use Slim\App;

class WebUIRouteProvider
{
    public static function register(App $app): void
    {
        $app->get('/categories/create', GetFormCreateCategorieAction::class);
        $app->post('/categories/create', PostCreateCategorieAction::class);
    }
}
