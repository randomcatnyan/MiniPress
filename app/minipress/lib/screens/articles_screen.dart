import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/article_provider.dart';
import 'articles_complet_screen.dart';

class ArticlesScreen extends ConsumerWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArticles = ref.watch(articlesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: asyncArticles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (articles) => ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            final nomAuteur = article.auteur['nom'] ?? 'Inconnu';

            return ListTile(
              title: Text(article.titre),
              subtitle: Text('Créé le : ${article.cree} — par $nomAuteur'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final String urlLien = article.lien;
                final int id = int.parse(urlLien.split('/').last);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleCompletScreen(articleId: id),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
