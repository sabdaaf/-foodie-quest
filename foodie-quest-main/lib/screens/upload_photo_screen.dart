import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../utils/image_helper.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File? _image;
  final _captionController = TextEditingController();

  Future<void> _pickImage() async {
    final file = await ImageHelper.pickImage(ImageSource.gallery);
    setState(() {
      _image = file;
    });
  }

  Future<void> _takePhoto() async {
    final file = await ImageHelper.pickImage(ImageSource.camera);
    setState(() {
      _image = file;
    });
  }

  Future<void> _upload(BuildContext context) async {
    if (_image == null) return;

    final success = await Provider.of<PhotoProvider>(context, listen: false)
        .uploadPhoto(_image!, _captionController.text);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload successful!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Photo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : const Icon(Icons.add_a_photo, size: 50),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
                TextButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ],
            ),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(labelText: 'Caption'),
            ),
            const SizedBox(height: 20),
            Consumer<PhotoProvider>(
              builder: (context, provider, child) {
                return provider.isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed:
                            _image != null ? null : () => _upload(context),
                        child: const Text('Upload'),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
