class Article {
  final String titre;
  final String cree;
  final String lien;
  final Map<String, dynamic> auteur;

  Article({
    required this.titre,
    required this.cree,
    required this.lien,
    required this.auteur,
  });

  factory Article.fromJson(Map<String, dynamic> data) {
    return Article(
      titre: data['titre'] as String,
      cree: data['cree'] as String,
      lien: data['lien'] as String,
      auteur: data['auteur'] as Map<String, dynamic>,
    );
  }

  @override
  String toString() => "Article(titre: $titre, cree: $cree, lien: $lien)";
}