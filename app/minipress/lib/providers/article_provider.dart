import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import '../services/api_service.dart';

final articlesProvider = FutureProvider<List<Article>>((ref) async {
  final api = ApiService();
  return api.getArticles();
});

final articlesByCategorieProvider = FutureProvider.family<List<Article>, int>((ref, categorieId) async {
  final api = ApiService();
  return api.getArticlesByCategorie(categorieId);
});
