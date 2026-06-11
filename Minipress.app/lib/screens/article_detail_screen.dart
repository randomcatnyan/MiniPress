import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/article.dart';
import '../services/api_service.dart';

// Écran de détail qui affiche le contenu complet d'un article
class ArticleDetailScreen extends StatefulWidget {
  final String? lien; // Le lien API pour charger l'article complet (ex: /api/articles/5)
  final String titre; // Le titre temporaire à afficher pendant le chargement

  const ArticleDetailScreen({
    super.key,
    required this.lien,
    required this.titre,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ApiService _apiService = ApiService(); // Le service pour récupérer l'article depuis l'API
  late Future<Article> _articleFuture; // Variable contenant l'état futur de l'article chargé

  @override
  void initState() {
    super.initState();
    _load(); // Lance le chargement dès que la page s'ouvre
  }

  // Déclenche la requête HTTP pour récupérer les détails de l'article
  void _load() {
    if (widget.lien != null) {
      _articleFuture = _apiService.fetchArticleByLien(widget.lien!);
    } else {
      _articleFuture = Future.error('Lien manquant.');
    }
  }

  // Formatage de la date en jour/mois/année (ex: "11/06/2026")
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy', 'fr_FR').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titre), // Titre dans la barre du haut
      ),
      // Le FutureBuilder permet d'afficher différents widgets selon que l'API est en train de charger,
      // a échoué ou a renvoyé les données de l'article.
      body: FutureBuilder<Article>(
        future: _articleFuture,
        builder: (context, snapshot) {
          // Cas 1 : En cours de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // Affiche un cercle de chargement qui tourne
            );
          }
          // Cas 2 : Erreur de chargement (ex: pas d'internet)
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => setState(() => _load()), // Bouton pour recommencer le chargement
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          // Cas 3 : Chargement réussi avec succès
          else if (snapshot.hasData) {
            final article = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Affiche l'image d'illustration si elle existe
                  if (article.imageUrl != null && article.imageUrl!.isNotEmpty) ...[
                    Image.network(
                      article.imageUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover, // Adapte l'image au conteneur
                      errorBuilder: (context, error, stackTrace) => const SizedBox(), // Cache l'image en cas d'erreur de chargement
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Titre de l'article
                  Text(
                    article.titre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Date de publication
                  Text(
                    'Publié le: ${_formatDate(article.cree)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  // Auteur de l'article (cliquable pour filtrer)
                  if (article.auteurNom != null) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        // Retourne à l'écran d'accueil en lui transmettant le nom de l'auteur sélectionné
                        Navigator.of(context).pop(article.auteurNom!);
                      },
                      child: Text(
                        'Auteur: ${article.auteurNom!}',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                  // Nom de la catégorie
                  if (article.categorieNom != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Catégorie: ${article.categorieNom!}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(), // Ligne de séparation horizontale
                  const SizedBox(height: 16),
                  // Résumé de l'article (en gras et italique)
                  if (article.resume != null && article.resume!.isNotEmpty) ...[
                    Text(
                      article.resume!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Contenu complet de l'article
                  if (article.contenu != null && article.contenu!.isNotEmpty)
                    Text(
                      article.contenu!,
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
            );
          }
          // Cas par défaut (si pas de données)
          return const Center(child: Text('Aucune donnée.'));
        },
      ),
    );
  }
}
