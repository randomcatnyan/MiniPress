import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String? lien;
  final String titre;

  const ArticleDetailScreen({
    super.key,
    required this.lien,
    required this.titre,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Article> _articleFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    if (widget.lien != null) {
      _articleFuture = _apiService.fetchArticleByLien(widget.lien!);
    } else {
      _articleFuture = Future.error('Lien manquant.');
    }
  }

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
        title: Text(widget.titre),
      ),
      body: FutureBuilder<Article>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => setState(() => _load()),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final article = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.imageUrl != null && article.imageUrl!.isNotEmpty) ...[
                    Image.network(
                      article.imageUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    article.titre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Publié le: ${_formatDate(article.cree)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (article.auteurNom != null) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
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
                  if (article.categorieNom != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Catégorie: ${article.categorieNom!}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
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
                  if (article.contenu != null && article.contenu!.isNotEmpty)
                    Text(
                      article.contenu!,
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
            );
          }
          return const Center(child: Text('Aucune donnée.'));
        },
      ),
    );
  }
}
