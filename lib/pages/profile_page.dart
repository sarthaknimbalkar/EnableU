import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User data
  final User currentUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('users');

  // Method to edit a specific field
  Future<void> editField(String field) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Edit $field',
              style: const TextStyle(color: Colors.white),
            ),
            content: TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter new $field",
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                newValue = value;
              },
            ),
            actions: [
              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // Save button
              TextButton(
                onPressed: () => Navigator.of(context).pop(newValue),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    // Update Firestore only if there's a new non-empty value
    if (newValue
        .trim()
        .isNotEmpty) {
      await userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          'Profile Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[700],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userCollection.doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>?;

            // If userData is null, show an error
            if (userData == null) {
              return const Center(
                child: Text("User data not found."),
              );
            }

            return SingleChildScrollView( // Wrap the content in a scroll view
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // Profile picture
                  const Center(
                    child: Icon(
                      Icons.person,
                      size: 72,
                    ),
                  ),
                  // Email
                  Center(
                    child: Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My details',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Username
                  MyTextBox(
                    text: userData['username'] ?? 'No username',
                    sectionName: 'Username',
                    onPressed: () => editField('username'),
                  ),
                  const SizedBox(height: 25),

                  // Bio
                  MyTextBox(
                    text: userData['bio'] ?? 'No bio available',
                    sectionName: 'Bio',
                    onPressed: () => editField('bio'),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
