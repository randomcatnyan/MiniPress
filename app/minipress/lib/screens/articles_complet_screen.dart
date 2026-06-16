import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class ArticleCompletScreen extends StatefulWidget {
  final int articleId;

  const ArticleCompletScreen({super.key, required this.articleId});

  @override
  State<ArticleCompletScreen> createState() => _ArticleCompletScreenState();
}

class _ArticleCompletScreenState extends State<ArticleCompletScreen> {
  final ApiService _apiService = ApiService();
  late Future<Article> _futureArticle;

  @override
  void initState() {
    super.initState();
    _futureArticle = _apiService.getArticleById(widget.articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail de l\'article')),
      body: FutureBuilder<Article>(
        future: _futureArticle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('erreur : ${snapshot.error}'));
          }
          final article = snapshot.data!;
          final nomAuteur = article.auteur['nom'] ?? 'Inconnu';
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.titre,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Par $nomAuteur le ${article.cree}',
                  style: const TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
                const Divider(height: 30),
                  Text(
                    article.resume,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                Text(
                  article.contenu,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
