// ============================================================================
// B. LES MODÈLES DE DONNÉES : categorie.dart
// Il sert à structurer les données d'une catégorie récupérées de l'API.
//
// 1. Rôle du Modèle :
//    - Il permet de transformer les données JSON reçues de l'API en objet
//      utilisable en Dart via le constructeur nommé factory Categorie.fromJson.
//
// 2. Pourquoi des constructeurs de désérialisation ?
//    - L'API envoie des données sous forme de chaînes de caractères brutes
//      (JSON). Le rôle de ces constructeurs est d'extraire les données et de
//      sécuriser les types (comme convertir un ID de catégorie sous forme de
//      texte "3" en entier 3 de manière sécurisée).
// ============================================================================

class Categorie {
  final int id; // L'identifiant de la catégorie
  final String titre; // Le nom ou titre de la catégorie
  final String? description; // Une courte description de la catégorie (optionnelle)

  const Categorie({
    required this.id,
    required this.titre,
    this.description,
  });

  // Construit un objet Categorie à partir d'un objet JSON reçu de l'API
  factory Categorie.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    // Sécurité : essaie de convertir l'id en entier si c'est renvoyé comme du texte
    final parsedId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    return Categorie(
      id: parsedId,
      titre: (json['titre'] as String?) ?? 'Sans titre',
      description: json['description'] as String?,
    );
  }
}
