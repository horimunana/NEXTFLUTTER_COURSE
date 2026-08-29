import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/recipe.dart';
import '../../../core/services/recipe_service.dart';
import '../../../core/stores/recipe_store.dart';
import '../../../main.dart' show themeModeNotifier;
import '../../../responsive/responsive_builder.dart';
import '../../../widgets/recipe_card.dart';
import '../../../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _service = RecipeService();
  final RecipeStore _store = RecipeStore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _category = 'All';
  bool _loading = false;

  List<String> get _categories {
    final set = _store.recipes.map((r) => r.category).toSet();
    return ['All', ...set];
  }

  List<Recipe> get _filteredRecipes {
    if (_loading) return [];
    return _store.recipes.where((r) {
      final matchesCategory = _category == 'All' || r.category == _category;
      final q = _query.toLowerCase();
      final matchesQuery = q.isEmpty || r.name.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final recipes = await _service.fetchRecipes();
    if (mounted) {
      setState(() {
        _store.setRecipes(recipes);
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            tooltip: 'Toggle theme',
            onPressed: () {
              themeModeNotifier.value =
                  themeModeNotifier.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () => context.pushNamed('favorites'),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SearchBarWidget(
                hint: 'Search recipes...',
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListenableBuilder(
                listenable: _store,
                builder: (context, _) {
                  final categories = _categories;
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return ChoiceChip(
                        label: Text(cat),
                        selected: _category == cat,
                        onSelected: (_) => setState(() => _category = cat),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListenableBuilder(
                listenable: _store,
                builder: (context, _) {
                  final recipes = _filteredRecipes;
                  if (_loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (recipes.isEmpty) {
                    return const Center(child: Text('No recipes found'));
                  }
                  return ResponsiveBuilder(
                    builder: (context, breakpoint) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridColumnsFor(breakpoint),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
                          return RecipeCard(
                            recipe: recipe,
                            onTap: () => context.pushNamed(
                              'detail',
                              pathParameters: {'id': recipe.id},
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.local_pizza, size: 32),
                SizedBox(width: 12),
                Text('Recipe App', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('favorites');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Recipe'),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('add-recipe');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('about');
            },
          ),
        ],
      ),
    ),
  );
}
