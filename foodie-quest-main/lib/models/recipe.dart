class Recipe {
  final int id;
  final String title;
  final String description;
  final String ingredients;
  final String instructions;
  final String imageUrl;
  final double rating;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.rating,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      ingredients: json['ingredients'] as String,
      instructions: json['instruction'] as String,
      imageUrl: json['image_url'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'image_url': imageUrl,
      'rating': rating,
    };
  }
}
