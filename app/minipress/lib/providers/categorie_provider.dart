import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categorie.dart';
import '../services/api_service.dart';

final categoriesProvider = FutureProvider<List<Categorie>>((ref) async {
  final api = ApiService();
  return api.getCategories();
});