import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/article_provider.dart';

class CategorieArticlesScreen extends ConsumerWidget {
  final int categorieId;
  final String categorieTitre;

  const CategorieArticlesScreen({
    super.key,
    required this.categorieId,
    required this.categorieTitre,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArticles = ref.watch(articlesByCategorieProvider(categorieId));

    return Scaffold(
      appBar: AppBar(title: Text(categorieTitre)),
      body: asyncArticles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('Aucun article dans cette catégorie'));
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