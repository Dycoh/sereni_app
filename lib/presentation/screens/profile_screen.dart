// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : null,
            child: user?.photoURL == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? 'User',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            user?.email ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          ListTile(
            title: const Text('Edit Profile'),
            leading: const Icon(Icons.edit),
            onTap: () {
              // TODO: Implement edit profile
            },
          ),
          ListTile(
            title: const Text('Notification Settings'),
            leading: const Icon(Icons.notifications),
            onTap: () {
              // TODO: Implement notification settings
            },
          ),
          ListTile(
            title: const Text('Privacy Settings'),
            leading: const Icon(Icons.privacy_tip),
            onTap: () {
              // TODO: Implement privacy settings
            },
          ),
          ListTile(
            title: const Text('Help & Support'),
            leading: const Icon(Icons.help),
            onTap: () {
              // TODO: Implement help & support
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
    );
  }
}