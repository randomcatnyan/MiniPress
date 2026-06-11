import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../models/categorie.dart';

/// Service d'accès à l'API MiniPress.core
///
/// Endpoints consommés :
///   GET /api/articles               → liste [{titre, cree, auteur, lien}]
///   GET /api/articles/{id}          → détail complet
///   GET /api/categories             → liste [{id, titre, description}]
///   GET /api/categories/{id}/articles → {categorie:{id,titre}, articles:[...]}
///
/// URL de base :
///   - Émulateur Android  : http://10.0.2.2:8081
///   - Web / Desktop      : http://localhost:8081
///   - Appareil physique  : `http://<IP_MACHINE>:8081`
class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Récupère la liste des articles (ordre chronologique inverse)
  /// Retourne des Articles partiels avec {titre, cree, auteurNom, lien}
  Future<List<Article>> fetchArticles() async {
    final uri = Uri.parse('$baseUrl/api/articles');
    final response = await _client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => Article.fromListJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erreur ${response.statusCode} lors du chargement des articles.');
    }
  }

  /// Récupère le détail complet d'un article
  /// Utilise le lien fourni dans la liste ou construit l'URL avec l'ID
  Future<Article> fetchArticleByLien(String lien) async {
    // Le lien est relatif (ex: /api/articles/3), on construit l'URL complète
    final uri = lien.startsWith('http')
        ? Uri.parse(lien)
        : Uri.parse('$baseUrl$lien');

    final response = await _client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Article.fromDetailJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Article introuvable.');
    } else {
      throw Exception('Erreur ${response.statusCode} lors du chargement de l\'article.');
    }
  }

  /// Récupère le détail complet d'un article par son ID
  Future<Article> fetchArticleById(int id) async {
    return fetchArticleByLien('/api/articles/$id');
  }

  /// Récupère la liste de toutes les catégories
  Future<List<Categorie>> fetchCategories() async {
    final uri = Uri.parse('$baseUrl/api/categories');
    final response = await _client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => Categorie.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erreur ${response.statusCode} lors du chargement des catégories.');
    }
  }

  /// Récupère les articles d'une catégorie donnée
  /// L'API retourne : {categorie: {id, titre}, articles: [{titre, cree, auteur, lien}]}
  Future<List<Article>> fetchArticlesByCategorie(int categorieId) async {
    final uri = Uri.parse('$baseUrl/api/categories/$categorieId/articles');
    final response = await _client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> articlesJson = data['articles'] as List<dynamic>;
      return articlesJson
          .map((json) => Article.fromListJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erreur ${response.statusCode} lors du chargement des articles.');
    }
  }
}
