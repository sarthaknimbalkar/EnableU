import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/components/drawer.dart';
import 'package:fyp/pages/profile_page.dart';
import 'landing_page.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserScore> _leaderboard = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  // Fetches top 10 users by tries in ascending order
  Future<void> _fetchLeaderboard() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('tries', descending: false)
          .limit(10)
          .get();

      final loadedLeaderboard = snapshot.docs
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        return data != null
            ? UserScore(
          name: data['username'] ?? 'Anonymous',
          tries: data['tries'] ?? 0,
        )
            : null;
      })
          .whereType<UserScore>() // filters out any nulls
          .toList();

      setState(() => _leaderboard = loadedLeaderboard);
    } catch (e) {
      // Optional: add error handling, like showing a snackbar with the error message.
      print('Error loading leaderboard: $e');
    }
  }

  // General navigation helper
  void _navigateTo(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            text: "Leader",
            style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: " Board",
                style: TextStyle(
                    color: Colors.pink,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      drawer: MyDrawer(
        onProfileTap: () => _navigateTo(const ProfilePage()),
        onHomeTap: () => _navigateTo(const HomePage()),
        onLeaderboardTap: () => _navigateTo(const LeaderboardPage()),
      ),
      body: _leaderboard.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _leaderboard.length,
        itemBuilder: (context, index) {
          return LeaderboardTile(
            position: index + 1,
            userScore: _leaderboard[index],
          );
        },
      ),
    );
  }
}

// LeaderboardTile widget for a more modular code structure
class LeaderboardTile extends StatelessWidget {
  final int position;
  final UserScore userScore;

  const LeaderboardTile({
    Key? key,
    required this.position,
    required this.userScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    if (position == 1) {
      borderColor = Colors.amber;
    } else if (position == 2) {
      borderColor = Colors.grey;
    } else if (position == 3) {
      borderColor = Colors.brown;
    } else {
      borderColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 3.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Text(
            '$position',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          userScore.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Tries: ${userScore.tries}'),
      ),
    );
  }
}

// Simple data model for UserScore
class UserScore {
  final String name;
  final int tries;

  UserScore({required this.name, required this.tries});
}
