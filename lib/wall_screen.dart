import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class WallScreen extends StatefulWidget {
  const WallScreen({super.key});

  @override
  State<WallScreen> createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  List<Uint8List> postImages = [];

  Future<void> pickAndPreviewImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      final previewImage = result.files.single.bytes!;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("📸 Post Image?"),
          content: Image.memory(previewImage),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Post"),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  postImages.insert(0, previewImage);
                });

                // Auto-delete after 30 seconds
                Timer(const Duration(seconds: 30), () {
                  setState(() {
                    postImages.remove(previewImage);
                  });
                });
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('GhostTalk Wall'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: pickAndPreviewImage,
          )
        ],
      ),
      body: postImages.isEmpty
          ? const Center(
              child: Text(
                "No posts yet.",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: postImages.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Image.memory(postImages[index]),
                );
              },
            ),
    );
  }
}
