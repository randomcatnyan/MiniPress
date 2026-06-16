class Article {
  final int id;
  final String titre;
  final String cree;
  final String lien;
  final Map<String, dynamic> auteur;
  final String resume;
  final String contenu;

  Article({
    required this.id,
    required this.titre,
    required this.cree,
    required this.lien,
    required this.auteur,
    required this.resume,
    required this.contenu,
  });

  factory Article.fromJson(Map<String, dynamic> data) {
    return Article(
      id: int.tryParse(data['id'].toString()) ?? 0,
      titre: data['titre']?.toString() ?? '',
      cree: data['cree']?.toString() ?? '',
      lien: data['lien']?.toString() ?? '',
      auteur: data['auteur'] ?? {},
      resume: data['resume']?.toString() ?? '',
      contenu: data['contenu']?.toString() ?? '',
    );
  }

  @override
  String toString() =>
      "Article(id: $id, titre: $titre, cree: $cree, lien: $lien)";
}
