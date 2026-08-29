class Recipe {
  final String id;
  final String name;
  final String category;
  final int prepTime;
  final int cookTime;
  final int servings;
  final int difficulty;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.isFavorite,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      prepTime: json['prepTime'] as int,
      cookTime: json['cookTime'] as int,
      servings: json['servings'] as int,
      difficulty: json['difficulty'] as int,
      imageUrl: json['imageUrl'] as String,
      ingredients: (json['ingredients'] as List<dynamic>).cast<String>(),
      steps: (json['steps'] as List<dynamic>).cast<String>(),
      isFavorite: json['isFavorite'] as bool,
    );
  }

  int get totalTime => prepTime + cookTime;
}
