import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wilson_wings/widgets/button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  CreatePostPageState createState() => CreatePostPageState();
}

class CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String> uploadImage(File imageFile) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference storageRef =
        storage.ref().child('images/${DateTime.now()}.jpg');

    final TaskSnapshot uploadTask = await storageRef.putFile(imageFile);

    final String downloadURL = await uploadTask.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> createPost() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    if (_selectedImage != null) {
      String imageUrl = await uploadImage(_selectedImage!);
      final Map<String, dynamic> postData = {
        'title': _titleController.text,
        'summary': _summaryController.text,
        'content': _contentController.text,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(), // Optional: Add a timestamp
      };

      try {
        await firestore.collection('posts').add(postData);

        // Post created successfully
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true); // Return to previous screen
      } catch (e) {
        // Handle error
        // ignore: avoid_print
        print('Failed to create post: $e');
      }
    } else {
      // Handle the case when no image is selected
      // For example, show an error message or alert the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _selectedImage != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.file(_selectedImage!),
                    ),
                  )
                : const SizedBox.shrink(),
            TextButton(
             child: _selectedImage == null ? const Text('Pick Image') : const Text('Pick a diffrent image'),
              onPressed: () {
                _pickImage();
              },
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _summaryController,
              decoration: const InputDecoration(labelText: 'Summary'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              'Create Post',
              fullWidth: true,
              onPressed: () {
                createPost();
              },
            ),
          ],
        ),
      ),
    );
  }
}
