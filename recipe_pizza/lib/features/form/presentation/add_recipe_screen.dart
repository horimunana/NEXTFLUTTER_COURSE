import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/recipe.dart';
import '../../../core/stores/recipe_store.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  String _category = 'Classic';
  int _prepTime = 15;
  int _servings = 2;

  static const _categories = [
    'Classic',
    'Meat',
    'Vegetarian',
    'Spicy',
    'Gourmet',
    'Sweet',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  void _submit() {
    final valid = _formKey.currentState!.validate();
    if (!valid) return;

    final ingredients = _ingredientsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final recipe = Recipe(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      category: _category,
      prepTime: _prepTime,
      cookTime: 0,
      servings: _servings,
      difficulty: 1,
      imageUrl: '',
      ingredients: ingredients,
      steps: const [
        'This is a custom recipe you created.',
        'Enjoy cooking and share it with friends!',
      ],
      isFavorite: false,
    );

    RecipeStore.instance.addRecipe(recipe);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe added successfully')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Recipe name',
                    prefixIcon: Icon(Icons.abc),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Recipe name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _category = value ?? _category),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(
                    labelText: 'Ingredients (comma separated)',
                    prefixIcon: Icon(Icons.shopping_basket),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Add at least one ingredient';
                    }
                    if (value
                            .split(',')
                            .where((e) => e.trim().isNotEmpty)
                            .length <
                        2) {
                      return 'Add at least two ingredients';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: '$_prepTime',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Preparation time (minutes)',
                    prefixIcon: Icon(Icons.timer),
                  ),
                  validator: (value) {
                    final num = int.tryParse(value ?? '');
                    if (num == null || num <= 0) {
                      return 'Enter a valid positive number';
                    }
                    return null;
                  },
                  onChanged: (value) =>
                      _prepTime = int.tryParse(value) ?? _prepTime,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: '$_servings',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Servings',
                    prefixIcon: Icon(Icons.people),
                  ),
                  validator: (value) {
                    final num = int.tryParse(value ?? '');
                    if (num == null || num <= 0) {
                      return 'Enter a valid number of servings';
                    }
                    return null;
                  },
                  onChanged: (value) =>
                      _servings = int.tryParse(value) ?? _servings,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Recipe'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
