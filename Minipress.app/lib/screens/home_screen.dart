import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/categorie.dart';
import '../services/api_service.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Article> _articles = [];
  List<Categorie> _categories = [];
  int? _selectedCategorieId;

  bool _loadingArticles = true;
  bool _loadingCategories = true;
  String? _errorArticles;
  String? _errorCategories;

  String? _selectedAuthorName;
  String _searchQuery = '';
  bool _sortAscending = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Article> get _filteredAndSortedArticles {
    List<Article> list = List.from(_articles);

    if (_selectedAuthorName != null) {
      list = list.where((a) => a.auteurNom == _selectedAuthorName).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((a) {
        final titreMatch = a.titre.toLowerCase().contains(query);
        final resumeMatch = a.resume?.toLowerCase().contains(query) ?? false;
        return titreMatch || resumeMatch;
      }).toList();
    }

    list.sort((a, b) {
      final dateA = a.cree != null ? DateTime.tryParse(a.cree!) : null;
      final dateB = b.cree != null ? DateTime.tryParse(b.cree!) : null;

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return _sortAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });

    return list;
  }

  Future<void> _loadAll() async {
    await _loadArticles();
    await _loadCategories();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _loadingArticles = true;
      _errorArticles = null;
    });
    try {
      final articles = _selectedCategorieId == null
          ? await _apiService.fetchArticles()
          : await _apiService.fetchArticlesByCategorie(_selectedCategorieId!);
      setState(() {
        _articles = articles;
        _loadingArticles = false;
      });
    } catch (e) {
      debugPrint('Error loading articles: $e');
      setState(() {
        _errorArticles = e.toString();
        _loadingArticles = false;
      });
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCategories = true;
      _errorCategories = null;
    });
    try {
      final cats = await _apiService.fetchCategories();
      setState(() {
        _categories = cats;
        _loadingCategories = false;
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
      setState(() {
        _errorCategories = e.toString();
        _loadingCategories = false;
      });
    }
  }

  void _selectCategorie(int? categorieId) {
    if (_selectedCategorieId == categorieId) return;
    setState(() {
      _selectedCategorieId = categorieId;
      _selectedAuthorName = null;
    });
    _loadArticles();
  }

  void _navigateToDetail(Article article) async {
    final selectedAuthor = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(
          lien: article.lien,
          titre: article.titre,
        ),
      ),
    );
    if (selectedAuthor != null) {
      setState(() {
        _selectedAuthorName = selectedAuthor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAndSortedArticles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MiniPress'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${filtered.length} article(s)',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section des catégories
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Catégories',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          if (_loadingCategories)
            const Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ))
          else if (_errorCategories != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Erreur catégories: $_errorCategories',
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Tous'),
                    selected: _selectedCategorieId == null,
                    onSelected: (selected) => _selectCategorie(null),
                  ),
                  const SizedBox(width: 8),
                  ..._categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat.titre),
                        selected: _selectedCategorieId == cat.id,
                        onSelected: (selected) => _selectCategorie(cat.id),
                      ),
                    );
                  }),
                ],
              ),
            ),

          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Rechercher un article...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Filtre d'auteur actif
          if (_selectedAuthorName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Chip(
                label: Text('Auteur: $_selectedAuthorName'),
                onDeleted: () => setState(() => _selectedAuthorName = null),
              ),
            ),

          // Ligne avec titre de la catégorie + bouton de tri
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategorieId == null
                      ? 'Tous les articles'
                      : _categories
                          .firstWhere((c) => c.id == _selectedCategorieId,
                              orElse: () => const Categorie(id: -1, titre: ''))
                          .titre,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _sortAscending = !_sortAscending),
                  icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
                  label: Text(_sortAscending ? 'Plus anciens' : 'Plus récents'),
                ),
              ],
            ),
          ),

          // Liste des articles
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadAll,
              child: _loadingArticles
                  ? const Center(child: CircularProgressIndicator())
                  : _errorArticles != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Erreur articles: $_errorArticles'),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _loadAll,
                                child: const Text('Réessayer'),
                              ),
                            ],
                          ),
                        )
                      : filtered.isEmpty
                          ? const Center(child: Text('Aucun article disponible.'))
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                return ArticleCard(
                                  article: filtered[index],
                                  onTap: () => _navigateToDetail(filtered[index]),
                                  onAuthorTap: (author) {
                                    setState(() {
                                      _selectedAuthorName = author;
                                    });
                                  },
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
