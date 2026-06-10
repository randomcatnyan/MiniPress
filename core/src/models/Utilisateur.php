<?php

namespace minipress\core\models;

use Illuminate\Database\Eloquent\Model;

class Utilisateur extends Model
{
    protected $table = 'utilisateurs';

    protected $fillable = ['nom', 'email', 'mdp'];

    protected $hidden = ['mdp'];

    const CREATED_AT = 'cree';
    const UPDATED_AT = 'maj';
}
