import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final String userId;

  UserPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: FutureBuilder(
        future: supabase.from('profiles').select().eq('id', userId).single(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userProfile = snapshot.data;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userProfile['avatar_url'] ?? ''),
              ),
              Text('Username: ${userProfile['username']}'),
              Text('Email: ${userProfile['useremail']}'),
            ],
          );
        },
      ),
    );
  }
}
