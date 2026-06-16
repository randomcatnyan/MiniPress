class Categorie {
  final int id;
  final String titre;
  final String? description;

  Categorie({
    required this.id,
    required this.titre,
    this.description,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description'] as String?,
    );
  }
}