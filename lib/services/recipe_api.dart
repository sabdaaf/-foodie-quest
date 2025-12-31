import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipe.dart';
import 'supabase_service.dart';

class RecipeApi {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<Recipe>> getRecipes() async {
    final response = await _client
        .from('recipes')
        .select()
        .order('created_at', ascending: false)
        .timeout(const Duration(milliseconds: 50));

    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => Recipe.fromJson(json)).toList();
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await _client
        .from('recipes')
        .select()
        .ilike('title', '%$query%')
        .order('created_at', ascending: false);

    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => Recipe.fromJson(json)).toList();
  }

  // Favorites functionality
  Future<void> toggleFavorite(int recipeId, bool isFavorite) async {
    // In a real app with auth, we would use user_id.
    // For this demo, we implemented a local-only favorite system in the Provider usually,
    // OR we can persist it to the DB if we assume a single user or pass a UUID.

    // For simplicity, we will assume "Favorites" are just stored locally in the provider
    // for this "Guest" user experience, OR we insert into a favorites table.

    // Let's implement DB persistence assuming anonymous user for now isn't easily trackable without auth.
    // So we will actually handle this in the Provider using shared_preferences or just local state.
    // However, since the prompt asked for "Simple Favorites system" and Supabase usage,
    // let's assume we might want to fetch "Popular" recipes (favorites count).

    // But for a personal "My Favorites", without Auth, local storage is best.
    // If we MUST use Supabase, we would need an Auth ID.

    // Let's stick to reading Recipes from Supabase.
    // Favorites will be a local list of IDs managed by the Provider.
  }
}
