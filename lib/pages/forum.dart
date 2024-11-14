import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/drawer.dart';
import 'package:fyp/components/forum_post.dart';
import 'package:fyp/components/text_field.dart';
import 'package:fyp/pages/profile_page.dart';

import '../helper/helper_methods.dart';

class Forum extends StatefulWidget {
  const Forum({Key? key}) : super(key: key);

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController textController = TextEditingController();

  // Post a new message to Firestore
  Future<void> postMessage() async {
    if (textController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection("user posts").add({
          'UserEmail': currentUser?.email,
          'message': textController.text,
          'TimeStamp': Timestamp.now(),
          'Likes': [],
        });
        // Clear text after posting
        textController.clear();
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post added successfully!')),
        );
      } catch (e) {
        print('Error posting message: $e');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add post. Please try again.')),
        );
      }
    } else {
      // Show warning if text field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message before posting.')),
      );
    }
  }

  // Navigate to home page
  void goToHomePage() {
    Navigator.pop(context);
  }

  // Navigate to profile page
  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          'Discussion Forum',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[700],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onHomeTap: goToHomePage,
      ),
      body: Column(
        children: [
          // StreamBuilder to fetch posts
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user posts")
                  .orderBy("TimeStamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No posts available'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data!.docs[index];
                    return ForumPost(
                      message: post['message'],
                      user: post['UserEmail'],
                      postID: post.id,
                      time: formatData(post['TimeStamp']),
                    );
                  },
                );
              },
            ),
          ),

          // Text input and post button
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: textController,
                    hintText: 'Create your post',
                    obscureText: false,
                  ),
                ),
                IconButton(
                  onPressed: postMessage,
                  icon: const Icon(
                    Icons.arrow_circle_up,
                    size: 40.0,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
