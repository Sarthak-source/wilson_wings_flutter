import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wilson_wings/screens/home/create_post.dart';
import 'package:wilson_wings/widgets/alert_box.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
        fetchPosts() async {
      try {
        final QuerySnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('posts').get();

        return snapshot.docs;
      } catch (error) {
        MyDialog.show(context, 'Error while fetching posts: $error');
        return [];
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostPage()),
          ).then((result) {
            if (result == true) {
              // Refresh the post list after creating a new post
              setState(() {});
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh the posts by calling the fetchPosts function
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          } else {
            final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                snapshot.data!;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final post = docs[index].data();
                return ListTile(
                  leading: ClipRRect( borderRadius: BorderRadius.circular(10.0),child: Image.network(post['imageUrl'])),
                  title: Text(post['title'] ?? ''),
                  subtitle: Text(post['summary'] ?? ''),
                  // Add more UI elements to display post details
                );
              },
            );
          }
        },
      ),
    );
  }
}
