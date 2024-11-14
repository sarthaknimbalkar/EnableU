import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/Games/gamesmain.dart';
import 'package:fyp/pages/forum.dart';
import 'package:fyp/pages/leaderboard.dart';
import 'package:fyp/pages/quotes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
  }

  void _signOut(BuildContext context) {
    _auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final email = currentUser?.email ?? '';
    final name = email.split('@').first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Welcome $name',
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text('No user data found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final username = userData['username'] ?? 'User';

          return _buildUserDashboard(context, username);
        },
      ),
    );
  }

  // Builds the main dashboard content
  Widget _buildUserDashboard(BuildContext context, String username) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome $username',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          const CircleAvatar(
            backgroundColor: Colors.yellow,
            radius: 60.0,
            child: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 50.0,
            ),
          ),
          const SizedBox(height: 40.0),
          // Dashboard navigation buttons
          _buildDashboardButton(
            context,
            'Discussion Forum',
            const Forum(),
          ),
          const SizedBox(height: 20.0),
          _buildDashboardButton(
            context,
            'Play Games',
            GamesListPage(),
          ),
          const SizedBox(height: 20.0),
          _buildDashboardButton(
            context,
            'Leaderboard',
            const LeaderboardPage(),
          ),
          const SizedBox(height: 20.0),
          _buildDashboardButton(
            context,
            'Quote for the day',
            QuotePage(),
          ),
        ],
      ),
    );
  }

  // Reusable Button Widget for Navigation
  Widget _buildDashboardButton(BuildContext context, String text, Widget route) {
    return GestureDetector(
      onTap: () {
        try {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        } catch (e) {
          print('Error navigating to $text page: $e');
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
