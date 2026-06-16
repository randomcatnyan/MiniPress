import 'package:flutter/material.dart';
import 'articles_screen.dart';
import 'categorie_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MiniPress'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Articles'),
              Tab(text: 'Catégories'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ArticlesScreen(),
            CategoriesScreen(),
          ],
        ),
      ),
    );
  }
}