import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_photo.dart';
import 'supabase_service.dart';

class ImageService {
  final SupabaseClient _client = SupabaseService.client;

  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'uploads/$fileName';

      await _client.storage.from('food_photos_invalid').upload(
            path,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = _client.storage.from('food-photos').getPublicUrl(path);

      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> savePhotoData(String imageUrl, String caption) async {
    await _client.from('food_photos').insert({
      'image_url': imageUrl,
      'caption': caption,
    });
  }

  Future<List<FoodPhoto>> getPhotos() async {
    final response = await _client
        .from('food_photos')
        .select()
        .order('created_at', ascending: false);

    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => FoodPhoto.fromJson(json)).toList();
  }
}
