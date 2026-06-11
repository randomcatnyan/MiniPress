import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/categorie.dart';
import '../services/api_service.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

// Écran principal de l'application (liste des articles et catégories)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Service pour faire les requêtes HTTP vers l'API
  final ApiService _apiService = ApiService();

  // Listes pour stocker les données de l'API
  List<Article> _articles = [];
  List<Categorie> _categories = [];
  
  // Identifiant de la catégorie sélectionnée (null = "Tous")
  int? _selectedCategorieId;

  // États de chargement et de gestion des erreurs
  bool _loadingArticles = true;
  bool _loadingCategories = true;
  String? _errorArticles;
  String? _errorCategories;

  // Filtres actifs en mémoire
  String? _selectedAuthorName; // Nom de l'auteur sélectionné pour le filtrage
  String _searchQuery = ''; // Texte saisi dans la barre de recherche
  bool _sortAscending = false; // Tri de la date (false = plus récent d'abord, true = plus ancien)
  
  // Contrôleur pour le champ de texte de recherche
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Charger toutes les données (articles et catégories) au démarrage
    _loadAll();
  }

  @override
  void dispose() {
    // Libérer la mémoire du contrôleur de texte
    _searchController.dispose();
    super.dispose();
  }

  // Getter qui filtre et trie la liste des articles localement
  List<Article> get _filteredAndSortedArticles {
    // Copier la liste de base des articles récupérés de l'API
    List<Article> list = List.from(_articles);

    // 1. Filtrer par auteur si un auteur est sélectionné
    if (_selectedAuthorName != null) {
      list = list.where((a) => a.auteurNom == _selectedAuthorName).toList();
    }

    // 2. Filtrer par mot-clé (dans le titre ou le résumé) si la recherche n'est pas vide
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((a) {
        final titreMatch = a.titre.toLowerCase().contains(query);
        final resumeMatch = a.resume?.toLowerCase().contains(query) ?? false;
        return titreMatch || resumeMatch;
      }).toList();
    }

    // 3. Trier par date de création (croissant ou décroissant)
    list.sort((a, b) {
      final dateA = a.cree != null ? DateTime.tryParse(a.cree!) : null;
      final dateB = b.cree != null ? DateTime.tryParse(b.cree!) : null;

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      // Trier selon la préférence de l'utilisateur
      return _sortAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });

    return list;
  }

  // Charger les articles et les catégories séquentiellement (l'un après l'autre)
  Future<void> _loadAll() async {
    await _loadArticles();
    await _loadCategories();
  }

  // Récupérer les articles depuis l'API PHP
  Future<void> _loadArticles() async {
    setState(() {
      _loadingArticles = true;
      _errorArticles = null;
    });
    try {
      // Si aucune catégorie n'est sélectionnée, charger tous les articles. Sinon, charger ceux de la catégorie.
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

  // Récupérer la liste des catégories depuis l'API PHP
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

  // Sélectionner une catégorie et recharger les articles correspondants
  void _selectCategorie(int? categorieId) {
    if (_selectedCategorieId == categorieId) return;
    setState(() {
      _selectedCategorieId = categorieId;
      _selectedAuthorName = null; // Réinitialiser le filtre d'auteur
    });
    _loadArticles();
  }

  // Naviguer vers l'écran de détail d'un article
  void _navigateToDetail(Article article) async {
    // Attendre le retour de l'écran (si l'utilisateur a cliqué sur le nom d'un auteur dans les détails)
    final selectedAuthor = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(
          lien: article.lien,
          titre: article.titre,
        ),
      ),
    );
    // Si un auteur a été sélectionné dans les détails, appliquer le filtre
    if (selectedAuthor != null) {
      setState(() {
        _selectedAuthorName = selectedAuthor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la liste filtrée et triée des articles
    final filtered = _filteredAndSortedArticles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MiniPress'),
        actions: [
          // Affichage du nombre d'articles en haut à droite
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
          // 1. En-tête de la section des catégories
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Catégories',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          
          // 2. Affichage des catégories (chargement, erreur ou liste déroulante)
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
                  // Puce "Tous" pour réinitialiser le filtre de catégorie
                  ChoiceChip(
                    label: const Text('Tous'),
                    selected: _selectedCategorieId == null,
                    onSelected: (selected) => _selectCategorie(null),
                  ),
                  const SizedBox(width: 8),
                  // Afficher chaque catégorie récupérée de l'API
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

          // 3. Champ de saisie pour la recherche par mot-clé
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

          // 4. Badge affiché si un filtre d'auteur est actif
          if (_selectedAuthorName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Chip(
                label: Text('Auteur: $_selectedAuthorName'),
                onDeleted: () => setState(() => _selectedAuthorName = null), // Bouton "X" pour enlever le filtre
              ),
            ),

          // 5. Ligne de titre de la catégorie actuelle et bouton de tri
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
                // Bouton interactif pour inverser le tri chronologique
                TextButton.icon(
                  onPressed: () => setState(() => _sortAscending = !_sortAscending),
                  icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
                  label: Text(_sortAscending ? 'Plus anciens' : 'Plus récents'),
                ),
              ],
            ),
          ),

          // 6. Section de la liste des articles
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadAll, // Gérer le glisser-déposer pour rafraîchir (pull-to-refresh)
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
                                // Renvoyer une carte d'article personnalisée
                                return ArticleCard(
                                  article: filtered[index],
                                  onTap: () => _navigateToDetail(filtered[index]),
                                  onAuthorTap: (author) {
                                    // Filtrer la liste par auteur au clic sur son nom
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
