import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_api.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeApi _api = RecipeApi();

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  final Set<int> _favoriteIds = {};
  Set<int> get favoriteIds => _favoriteIds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchRecipes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _recipes = await _api.getRecipes();
    } catch (e) {
      debugPrint("Error fetching recipes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) {
      await fetchRecipes();
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      _recipes = await _api.searchRecipes(query);
    } catch (e) {
      debugPrint("Error searching recipes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(int recipeId) {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
  }

  bool isFavorite(int recipeId) {
    return _favoriteIds.contains(recipeId);
  }

  List<Recipe> get favoriteRecipes {
    return _recipes.where((r) => _favoriteIds.contains(r.id)).toList();
  }
}
