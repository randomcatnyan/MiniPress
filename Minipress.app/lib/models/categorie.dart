// Modèle de données pour représenter une Catégorie d'articles
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
