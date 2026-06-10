<?php
namespace minipress\core\application_core\domain\entities;

use Illuminate\Database\Eloquent\Model;

class Categorie extends Model
{
    protected $table = 'categories';
    public $timestamps = false;
    protected $fillable = ['titre', 'description'];

    public function articles()
    {
        return $this->hasMany(Article::class, 'categorie_id');
    }
}