import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/recipe_provider.dart';
import '../providers/photo_provider.dart';
import '../screens/recipe_detail_screen.dart';
import '../screens/upload_photo_screen.dart';
import '../utils/date_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecipeProvider>(context, listen: false).fetchRecipes();
      Provider.of<PhotoProvider>(context, listen: false).fetchPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodieQuest'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Recipes'),
            Tab(text: 'Photos'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecipeTab(),
          _buildPhotoTab(),
          _buildFavoritesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadPhotoScreen()),
          );
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildRecipeTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Recipes...',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  Provider.of<RecipeProvider>(context, listen: false)
                      .searchRecipes('');
                },
              ),
            ),
            onSubmitted: (value) {
              Provider.of<RecipeProvider>(context, listen: false)
                  .searchRecipes(value);
            },
          ),
        ),
        Expanded(
          child: Consumer<RecipeProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.recipes.isEmpty) {
                return const Center(child: Text('No recipes found.'));
              }
              return ListView.builder(
                itemCount: provider.recipes.length + 1,
                itemBuilder: (context, index) {
                  final recipe = provider.recipes[index];
                  return ListTile(
                    leading: recipe.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: recipe.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                const SizedBox(width: 50, height: 50),
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.restaurant),
                    title: Text(recipe.title),
                    subtitle: Text(recipe.description,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Icon(
                      provider.isFavorite(recipe.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: provider.isFavorite(recipe.id) ? Colors.red : null,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailScreen(recipe: recipe),
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
    );
  }

  Widget _buildFavoritesTab() {
    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favoriteRecipes;
        if (favorites.isEmpty) {
          return const Center(child: Text('No favorites yet.'));
        }
        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final recipe = favorites[index];
            return ListTile(
              title: Text(recipe.title),
              subtitle: Text('Rating: ${recipe.rating}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  provider.toggleFavorite(recipe.id);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPhotoTab() {
    return Consumer<PhotoProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.photos.isEmpty) {
          return const Center(child: Text('No photos uploaded yet.'));
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: provider.photos.length,
          itemBuilder: (context, index) {
            final photo = provider.photos[index];
            return GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(photo.caption),
                subtitle: Text(DateHelper.formatRelative(photo.createdAt)),
              ),
              child: CachedNetworkImage(
                imageUrl: photo.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            );
          },
        );
      },
    );
  }
}
