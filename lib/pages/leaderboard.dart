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
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .orderBy('tries', descending: false)
        .limit(10)
        .get();

    List<UserScore> loadedLeaderboard = [];
    for (var document in snapshot.docs) {
      var data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        loadedLeaderboard.add(UserScore(
          name: data['username'] ?? 'Anonymous',
          tries: data['tries'] as int? ?? 0,
        ));
      }
    }

    setState(() {
      _leaderboard = loadedLeaderboard;
    });
  }

  void goToHomePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  void goToLeaderboard() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeaderboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Leaderboard",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onHomeTap: goToHomePage,
        onLeaderboardTap: goToLeaderboard,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurpleAccent.shade200,
              Colors.pinkAccent.shade100,
            ],
          ),
        ),
        child: _leaderboard.isEmpty
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0, bottom: 20.0),
              child: Text(
                "Top Players",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _leaderboard.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: index == 0
                            ? Colors.amber
                            : index == 1
                            ? Colors.grey
                            : index == 2
                            ? Colors.brown
                            : Colors.blueGrey,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      title: Text(
                        _leaderboard[index].name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Text(
                        'Tries: ${_leaderboard[index].tries}',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      trailing: Icon(
                        Icons.star,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserScore {
  final String name;
  final int tries;

  UserScore({required this.name, required this.tries});
}
