/// Modèle de données pour une Catégorie MiniPress
class Categorie {
  final int id;
  final String titre;
  final String? description;

  const Categorie({
    required this.id,
    required this.titre,
    this.description,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
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
