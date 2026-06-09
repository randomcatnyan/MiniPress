<?php

declare(strict_types=1);

namespace minipress\core\application_core\domain;

use Illuminate\Database\Eloquent\Model;

class Categorie extends Model
{
    protected $table = 'categorie';

    protected $fillable = ['titre', 'description'];
}
