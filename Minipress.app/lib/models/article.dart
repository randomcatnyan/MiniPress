// ============================================================================
// B. LES MODÈLES DE DONNÉES : article.dart
// Il sert à structurer les données d'un article récupérées de l'API.
//
// 1. Rôle du Modèle :
//    - Il permet de transformer les données JSON reçues de l'API en objet
//      utilisable en Dart via des constructeurs nommés factory (fromListJson,
//      fromDetailJson).
//
// 2. Pourquoi des constructeurs de désérialisation ?
//    - L'API envoie des données sous forme de chaînes de caractères brutes
//      (JSON). Le rôle de ces constructeurs est d'extraire les données et de
//      sécuriser les types (comme convertir un ID envoyé sous forme de texte
//      "3" en entier 3 grâce à une fonction de nettoyage).
// ============================================================================

class Article {
  final int? id; // L'identifiant unique de l'article (peut être nul si absent de la liste)
  final String titre; // Le titre de l'article
  final String? resume; // Le résumé court de l'article (optionnel)
  final String? contenu; // Le texte complet de l'article (optionnel)
  final String? imageUrl; // Le lien vers l'image d'illustration (optionnel)
  final int? categorieId; // L'identifiant de la catégorie de l'article (optionnel)
  final String? categorieNom; // Le nom textuel de sa catégorie (optionnel)
  final String? auteurNom; // Le nom de l'auteur de l'article (optionnel)
  final String? cree; // La date de création sous forme de texte (ex: "2026-06-11 10:00:00") (optionnel)
  final String? lien; // Le chemin vers l'API pour charger les détails de cet article (optionnel)

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

  // Construit un objet Article à partir du JSON simplifié renvoyé par la liste de l'API (/api/articles)
  factory Article.fromListJson(Map<String, dynamic> json) {
    return Article(
      titre: (json['titre'] as String?) ?? 'Sans titre',
      cree: json['cree'] as String?,
      auteurNom: json['auteur'] as String?,
      lien: json['lien'] as String?,
    );
  }

  // Construit un objet Article complet à partir du JSON détaillé renvoyé par l'API (/api/articles/{id})
  factory Article.fromDetailJson(Map<String, dynamic> json) {
    // Dans l'API, l'auteur peut être soit une simple chaîne de caractères (String),
    // soit un objet Map contenant {'nom': '...'}
    String? auteur;
    final auteurField = json['auteur'];
    if (auteurField is Map<String, dynamic>) {
      auteur = auteurField['nom'] as String?;
    } else if (auteurField is String) {
      auteur = auteurField;
    }

    // Récupère les infos de la catégorie imbriquée si elle existe
    final categorie = json['categorie'] as Map<String, dynamic>?;

    // Petite fonction utilitaire pour convertir en entier de manière sécurisée
    // car l'API peut parfois renvoyer des IDs sous forme de texte ("1" au lieu de 1)
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

  // Permet d'extraire l'ID de l'article depuis son lien API (ex: "/api/articles/5" -> 5)
  int? get idFromLien {
    if (lien == null) return null;
    final parts = lien!.split('/');
    return int.tryParse(parts.last);
  }
}
