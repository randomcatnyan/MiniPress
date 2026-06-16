import 'package:dio/dio.dart';
import '../models/article.dart';
import '../models/categorie.dart';

class ApiService {
  static const String baseUrl = 'http://docketu.iutnc.univ-lorraine.fr:30003/api';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<Article>> getArticles() async {
    final response = await _dio.get('/articles?sort=desc');
    final List<dynamic> data = response.data;
    return data.map((json) => Article.fromJson(json)).toList();
  }

  Future<List<Categorie>> getCategories() async {
    final response = await _dio.get('/categories');
    final List<dynamic> data = response.data;
    return data.map((json) => Categorie.fromJson(json)).toList();
  }
}