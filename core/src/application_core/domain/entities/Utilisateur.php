<?php
namespace minipress\core\application_core\domain\entities;

use Illuminate\Database\Eloquent\Model;

class Utilisateur extends Model
{
    protected $table = 'utilisateurs';
    public $timestamps = false;
    protected $fillable = ['nom', 'email', 'mdp'];

    public function articles()
    {
        return $this->hasMany(Article::class, 'auteur_id');
    }
}