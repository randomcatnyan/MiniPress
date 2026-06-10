<?php
namespace minipress\core\application_core\domain\entities;

use Illuminate\Database\Eloquent\Model;

class Article extends Model
{
    protected $table = 'articles';
    public $timestamps = false;
    protected $fillable = [
        'titre', 'resume', 'contenu', 'image_url',
        'categorie_id', 'auteur_id', 'publie'
    ];

    public function categorie()
    {
        return $this->belongsTo(Categorie::class, 'categorie_id');
    }

    public function auteur()
    {
        return $this->belongsTo(Utilisateur::class, 'auteur_id');
    }
}