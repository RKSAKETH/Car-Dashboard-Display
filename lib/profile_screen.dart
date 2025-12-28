import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Name
            const Text(
              "User Name",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),
            const Text("user@email.com"),

            const SizedBox(height: 30),

            // Options
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Trip History"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
