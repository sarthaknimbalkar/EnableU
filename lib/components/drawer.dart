import 'package:flutter/material.dart';
import 'package:fyp/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onHomeTap;
  final void Function()? onProfileTap;
  final void Function()? onLeaderboardTap;

  const MyDrawer({
    super.key,
    this.onHomeTap,
    this.onProfileTap,
    this.onLeaderboardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          // Header with icon or user avatar
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
                const SizedBox(height: 8),
                Text(
                  'Username', // Replace with dynamic data if available
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Navigation items
          MyListTile(
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              if (onHomeTap != null) onHomeTap!();
            },
          ),
          MyListTile(
            icon: Icons.person,
            text: 'Profile',
            onTap: () {
              if (onProfileTap != null) onProfileTap!();
            },
          ),
          MyListTile(
            icon: Icons.celebration,
            text: 'Leaderboard',
            onTap: () {
              if (onLeaderboardTap != null) onLeaderboardTap!();
            },
          ),
        ],
      ),
    );
  }
}
