import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/helper_methods.dart';
import 'comment.dart';
import 'delete_button.dart';
import 'like_button.dart';
import 'comment_button.dart';

class ForumPost extends StatefulWidget {
  final String message;
  final String user;
  final String postID;
  final String time;

  const ForumPost({
    super.key,
    required this.message,
    required this.user,
    required this.postID,
    required this.time,
  });

  @override
  State<ForumPost> createState() => _ForumPostState();
}

class _ForumPostState extends State<ForumPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  List<String> likes = [];

  final TextEditingController _commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post message and user info
            Text(widget.message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            UserInfoRow(user: widget.user, time: widget.time),

            // Like and comment buttons
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.user == currentUser.email) DeleteButton(onTap: deletePost),
                LikeButton(
                  isLiked: isLiked,
                  onTap: toggleLike,
                ),
                Text(
                  likes.length.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                CommentButton(onTap: showCommentDialog),
              ],
            ),
            // Comments List
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user posts")
                  .doc(widget.postID)
                  .collection('comments')
                  .orderBy('commenttime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Comment(
                      user: commentData['commentedby'],
                      text: commentData['commenttext'],
                      time: formatData(commentData['commenttime']),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likes.add(currentUser.email!);
      } else {
        likes.remove(currentUser.email!);
      }
    });

    final postRef =
    FirebaseFirestore.instance.collection('user posts').doc(widget.postID);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email!])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email!])
      });
    }
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add comment'),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Add a new comment"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String commentText = _commentTextController.text.trim();
              if (commentText.isNotEmpty) {
                addComment(commentText);
                _commentTextController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Post'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void deletePost() async {
    final postRef = FirebaseFirestore.instance
        .collection('user posts')
        .doc(widget.postID);

    await postRef.collection('comments').get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });

    await postRef.delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete post')),
      );
    });
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection('user posts')
        .doc(widget.postID)
        .collection('comments')
        .add({
      "commenttext": commentText,
      "commentedby": currentUser.email,
      "commenttime": Timestamp.now(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add comment')),
      );
    });
  }
}

class UserInfoRow extends StatelessWidget {
  final String user;
  final String time;

  const UserInfoRow({super.key, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(user, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(width: 5),
        Text("-", style: TextStyle(color: Colors.grey[600])),
        const SizedBox(width: 5),
        Text(time, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}
