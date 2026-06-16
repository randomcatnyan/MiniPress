import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/article_provider.dart';

class AuteurArticlesScreen extends ConsumerWidget {
  final int auteurId;
  final String auteurNom;

  const AuteurArticlesScreen({
    super.key,
    required this.auteurId,
    required this.auteurNom,

  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArticles = ref.watch(articlesByAuteurProvider(auteurId));

    return Scaffold(
      appBar: AppBar(title: Text(auteurNom)),
      body: asyncArticles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('Cet auteur ne possède aucun articles'));
          }
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ListTile(
                title: Text(article.titre),
                subtitle: Text('${article.cree} — ${article.auteur['nom']}'),
              );
            },
          );
        },
      ),
    );
  }
}
