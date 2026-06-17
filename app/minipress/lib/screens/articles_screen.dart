import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/article_provider.dart';
import 'articles_complet_screen.dart';
import 'auteur_articles_screen.dart';

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
            final idAuteur = int.tryParse(article.auteur['id'].toString()) ?? 0;
            return ListTile(
              title: Text(article.titre),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final String urlLien = article.lien;
                if (urlLien.isNotEmpty) {
                  final int id = int.parse(urlLien.split('/').last);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleCompletScreen(articleId: id),
                    ),
                  );
                }
              },
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Créé le : ${article.cree}'),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () {
                      if (idAuteur != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuteurArticlesScreen(
                              auteurId: idAuteur,
                              auteurNom: nomAuteur,
                            ),
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      'par $nomAuteur',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
