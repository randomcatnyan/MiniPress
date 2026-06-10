<?php

namespace minipress\core\utils;

use Illuminate\Database\Capsule\Manager as DB;

class Eloquent
{
    public static function init(string $filename): void
    {
        $db = new DB();
        $db->addConnection(parse_ini_file($filename));
        $db->setAsGlobal();
        $db->bootEloquent();
    }
}
