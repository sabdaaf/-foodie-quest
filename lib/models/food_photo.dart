class FoodPhoto {
  final int id;
  final String imageUrl;
  final String caption;
  final DateTime createdAt;

  FoodPhoto({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
  });

  factory FoodPhoto.fromJson(Map<String, dynamic> json) {
    return FoodPhoto(
      id: json['id'] as int,
      imageUrl: json['img_url'] as String,
      caption: json['caption'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'caption': caption,
    };
  }
}
