import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      return null;
    }
    return null;
  }
}
