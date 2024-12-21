import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/Games/gamesmain.dart';
import 'package:fyp/pages/forum.dart';
import 'package:fyp/pages/leaderboard.dart';
import 'package:fyp/pages/quotes.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late User? currentUser;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool isNightMode = true;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(); // Loop the animation indefinitely

    // Scale animation for tiles
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleTheme() {
    setState(() {
      isNightMode = !isNightMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = currentUser?.email ?? '';
    final name = email.split('@').first;

    final backgroundColor = isNightMode ? Color(0xFF121212) : Colors.white;
    final appBarColor = isNightMode ? Colors.blueGrey[900] : Colors.lightBlueAccent;
    final textColor = isNightMode ? Color(0xFFE0E0E0) : Colors.black;
    final appBarTextColor = isNightMode ? Color(0xFFE0E0E0) : Colors.blueGrey[900];
    final tileColors = [
      isNightMode ? Colors.orange.withOpacity(0.8) : Colors.deepOrangeAccent.withOpacity(0.9),
      isNightMode ? Colors.green.withOpacity(0.8) : Colors.lightGreenAccent.withOpacity(0.9),
      isNightMode ? Colors.blue.withOpacity(0.8) : Colors.lightBlue.withOpacity(0.9),
      isNightMode ? Colors.purple.withOpacity(0.8) : Colors.deepPurpleAccent.withOpacity(0.9),
    ];
    final tileTextColor = isNightMode ? Color(0xFFE0E0E0) : Colors.white70;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'Welcome $name',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: appBarTextColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: toggleTheme,
            icon: Icon(
              isNightMode ? Icons.light_mode : Icons.dark_mode,
              color: appBarTextColor,
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(Icons.logout, color: appBarTextColor),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Animated Background Symbols
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundSymbolPainter(
                  _animationController.value, isNightMode),
            ),
          ),
          // Blocks directly on the background
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    children: [
                      _buildAnimatedTile(
                        context,
                        'Discussion Forum',
                        Forum(),
                        Icons.forum,
                        tileColors[0],
                        tileTextColor,
                      ),
                      _buildAnimatedTile(
                        context,
                        'Play Games',
                        GamesListPage(),
                        Icons.videogame_asset,
                        tileColors[1],
                        tileTextColor,
                      ),
                      _buildAnimatedTile(
                        context,
                        'Leaderboard',
                        LeaderboardPage(),
                        Icons.leaderboard,
                        tileColors[2],
                        tileTextColor,
                      ),
                      _buildAnimatedTile(
                        context,
                        'Quote for the day',
                        QuotePage(),
                        Icons.format_quote,
                        tileColors[3],
                        tileTextColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1 + (_scaleAnimation.value * 0.1),
                      child: Text(
                        'Learn, Play, and Grow!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to create an animated tile
  Widget _buildAnimatedTile(BuildContext context, String title, Widget route,
      IconData icon, Color? color, Color textColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + (_scaleAnimation.value * 0.05),
            child: Container(
              decoration: BoxDecoration(
                color: color?.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: color!.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 50,
                    color: textColor,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom Painter for Background Symbols
class BackgroundSymbolPainter extends CustomPainter {
  final double animationValue;
  final bool isNightMode;

  BackgroundSymbolPainter(this.animationValue, this.isNightMode);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isNightMode
          ? Colors.blue.withOpacity(0.2)
          : Colors.yellow.withOpacity(0.2);

    // Draw circles moving across the screen
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.2 * i + animationValue * 0.2);
      final y = size.height * (0.2 * i + (1 - animationValue) * 0.2);

      // Skip areas where blocks are located
      if (x > size.width * 0.1 &&
          x < size.width * 0.9 &&
          y > size.height * 0.2 &&
          y < size.height * 0.8) {
        continue;
      }

      canvas.drawCircle(Offset(x % size.width, y % size.height), 20, paint);
    }

    // Draw squares moving across the screen
    paint.color = isNightMode
        ? Colors.green.withOpacity(0.2)
        : Colors.orange.withOpacity(0.2);
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.25 * i - animationValue * 0.2);
      final y = size.height * (0.25 * i + animationValue * 0.2);

      // Skip areas where blocks are located
      if (x > size.width * 0.1 &&
          x < size.width * 0.9 &&
          y > size.height * 0.2 &&
          y < size.height * 0.8) {
        continue;
      }

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x % size.width, y % size.height),
          width: 20,
          height: 20,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
