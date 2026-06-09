<?php

namespace minipress\core\utils;

use Illuminate\Database\Capsule\Manager as DB;

class Eloquent
{
    public static function init($filename): void
    {
        $db = new DB();
        // parse_ini_file renvoie directement le tableau des paramètres attendus par Eloquent
        $db->addConnection(parse_ini_file($filename));
        $db->setAsGlobal();
        $db->bootEloquent();
    }
}