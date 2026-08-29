import 'package:flutter/foundation.dart';

import '../models/recipe.dart';

class RecipeStore extends ChangeNotifier {
  RecipeStore._();

  static final RecipeStore instance = RecipeStore._();

  List<Recipe> _recipes = [];
  final Set<String> _favoriteIds = <String>{};

  List<Recipe> get recipes => List.unmodifiable(_recipes);

  List<Recipe> get favorites =>
      _recipes.where((r) => _favoriteIds.contains(r.id)).toList();

  void setRecipes(List<Recipe> items) {
    _recipes = items;
    for (final r in items) {
      if (r.isFavorite) _favoriteIds.add(r.id);
    }
    notifyListeners();
  }

  Recipe? byId(String id) {
    for (final r in _recipes) {
      if (r.id == id) return r;
    }
    return null;
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  void addRecipe(Recipe recipe) {
    _recipes = [..._recipes, recipe];
    notifyListeners();
  }

  void clear() {
    _recipes = [];
    _favoriteIds.clear();
    notifyListeners();
  }
}
