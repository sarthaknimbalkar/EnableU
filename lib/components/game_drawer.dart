import 'package:flutter/material.dart';
import 'package:fyp/components/my_list_tile.dart';

class MyGameDrawer extends StatelessWidget {
  final void Function()? onHomeTap;
  final void Function()? onGameTap;
  final void Function()? onLeaderboardTap;

  const MyGameDrawer({
    super.key,
    required this.onHomeTap,
    this.onGameTap,
    this.onLeaderboardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          // Drawer Header with Icon and Text
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.gamepad,
                  color: Colors.white,
                  size: 64,
                ),
                const SizedBox(height: 8),
                Text(
                  'Game Menu', // Dynamic text can be added here
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Home ListTile
          MyListTile(
            icon: Icons.home,
            text: 'Home',
            onTap: onHomeTap,
          ),
          // Game ListTile
          MyListTile(
            icon: Icons.games,
            text: 'Games',
            onTap: onGameTap,
          ),
          // Leaderboard ListTile
          MyListTile(
            icon: Icons.leaderboard,
            text: 'Leaderboard',
            onTap: onLeaderboardTap,
          ),
          const Divider(color: Colors.white24), // Divider to separate sections
          // Add other items or footer if necessary
        ],
      ),
    );
  }
}
