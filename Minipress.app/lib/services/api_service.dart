// ============================================================================
// C. LA COMMUNICATION RÉSEAU : api_service.dart
// Ce service effectue les requêtes HTTP vers votre API locale (sur l'adresse
// spéciale d'émulateur http://10.0.2.2:8081).
//
// 1. Méthodes asynchrones (Future) :
//    - Les requêtes réseau prennent du temps. Les fonctions renvoient donc un
//      `Future<List<Article>>` ou un `Future<Article>`, ce qui signifie "je
//      promets de te fournir le résultat plus tard".
//
// 2. Traitement des réponses :
//    - Si le serveur répond avec un code HTTP 200 (Succès), le JSON est décodé
//      (`jsonDecode`) et mappé vers nos objets Dart. Sinon, une erreur
//      (`throw Exception`) est générée.
// ============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../models/categorie.dart';

// Service qui gère toutes les requêtes réseau (HTTP) pour communiquer avec notre API MiniPress.
// C'est lui qui récupère les articles et les catégories depuis le serveur.
class ApiService {
  // L'adresse locale de l'API (10.0.2.2 est l'adresse spéciale pour accéder à l'ordinateur depuis l'émulateur Android)
  static const String baseUrl = 'http://10.0.2.2:8081';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Récupère la liste de tous les articles.
  // Renvoie une liste d'objets Article contenant uniquement les infos de base (titre, auteur, date, lien).
  Future<List<Article>> fetchArticles() async {
    final uri = Uri.parse('$baseUrl/api/articles');
    // On lance la requête GET avec un temps d'attente maximum (timeout) de 30 secondes
    final response = await _client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      // Si le serveur répond "OK", on décode le JSON reçu (qui est une liste)
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      // On convertit chaque élément JSON en objet Article
      return data
          .map((json) => Article.fromListJson(json as Map<String, dynamic>))
          .toList();
    } else {
      // Si le serveur renvoie une erreur, on lève une exception
      throw Exception('Erreur ${response.statusCode} lors du chargement des articles.');
    }
  }

  // Récupère le détail complet d'un article en utilisant son lien relatif (ex: /api/articles/3)
  Future<Article> fetchArticleByLien(String lien) async {
    // Si le lien commence déjà par http, on l'utilise directement, sinon on rajoute l'adresse de base
    final uri = lien.startsWith('http')
        ? Uri.parse(lien)
        : Uri.parse('$baseUrl$lien');

    final response = await _client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      // Décode le JSON de l'article complet (qui est une Map de clé-valeurs)
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Article.fromDetailJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Article introuvable.');
    } else {
      throw Exception('Erreur ${response.statusCode} lors du chargement de l\'article.');
    }
  }

  // Récupère le détail complet d'un article à partir de son identifiant numérique (ID)
  Future<Article> fetchArticleById(int id) async {
    return fetchArticleByLien('/api/articles/$id');
  }

  // Récupère la liste de toutes les catégories enregistrées
  Future<List<Categorie>> fetchCategories() async {
    final uri = Uri.parse('$baseUrl/api/categories');
    final response = await _client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      // Décode la liste JSON des catégories
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => Categorie.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erreur ${response.statusCode} lors du chargement des catégories.');
    }
  }

  // Récupère la liste des articles appartenant à une catégorie spécifique
  Future<List<Article>> fetchArticlesByCategorie(int categorieId) async {
    final uri = Uri.parse('$baseUrl/api/categories/$categorieId/articles');
    final response = await _client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      // L'API renvoie un objet contenant { "categorie": ..., "articles": [...] }
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
