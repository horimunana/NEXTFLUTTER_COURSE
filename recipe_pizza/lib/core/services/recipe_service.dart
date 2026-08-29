import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/recipe.dart';

class RecipeService {
  static const String _assetPath = 'assets/data/recipes.json';

  Future<List<Recipe>> fetchRecipes() async {
    final String raw = await rootBundle.loadString(_assetPath);
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    final List<dynamic> items = json['recipes'] as List<dynamic>;
    return items
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
