/// Modèle de données pour un Article MiniPress
/// Adapté au format JSON de l'API MiniPress.core (/api/articles et /api/articles/{id})
class Article {
  final int? id;
  final String titre;
  final String? resume;
  final String? contenu;
  final String? imageUrl;
  final int? categorieId;
  final String? categorieNom;
  /// Auteur : peut être un String (liste) ou extrait d'un objet (détail)
  final String? auteurNom;
  final String? cree;
  /// Lien vers l'API (fourni dans la liste)
  final String? lien;

  const Article({
    this.id,
    required this.titre,
    this.resume,
    this.contenu,
    this.imageUrl,
    this.categorieId,
    this.categorieNom,
    this.auteurNom,
    this.cree,
    this.lien,
  });

  /// Construit depuis la liste /api/articles → {titre, cree, auteur (string), lien}
  factory Article.fromListJson(Map<String, dynamic> json) {
    return Article(
      titre: (json['titre'] as String?) ?? 'Sans titre',
      cree: json['cree'] as String?,
      auteurNom: json['auteur'] as String?,
      lien: json['lien'] as String?,
    );
  }

  /// Construit depuis le détail /api/articles/{id}
  factory Article.fromDetailJson(Map<String, dynamic> json) {
    // L'auteur peut être un objet {nom: ...} ou une String
    String? auteur;
    final auteurField = json['auteur'];
    if (auteurField is Map<String, dynamic>) {
      auteur = auteurField['nom'] as String?;
    } else if (auteurField is String) {
      auteur = auteurField;
    }

    final categorie = json['categorie'] as Map<String, dynamic>?;

    int? parseInt(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      return int.tryParse(val.toString());
    }

    return Article(
      id: parseInt(json['id']),
      titre: (json['titre'] as String?) ?? 'Sans titre',
      resume: json['resume'] as String?,
      contenu: json['contenu'] as String?,
      imageUrl: json['image_url'] as String?,
      categorieId: parseInt(json['categorie_id']),
      categorieNom: categorie?['titre'] as String?,
      auteurNom: auteur,
      cree: json['cree'] as String?,
    );
  }

  /// Extrait l'ID numérique depuis le lien (ex: /api/articles/42)
  int? get idFromLien {
    if (lien == null) return null;
    final parts = lien!.split('/');
    return int.tryParse(parts.last);
  }
}
