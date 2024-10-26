import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

          // تحقق من أن snapshot.data ليس null
          final userProfile = snapshot.data as Map<String, dynamic>?;

          if (userProfile == null) {
            return Center(child: Text('User profile not found'));
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userProfile['avatar_url'] ?? ''),
              ),
              Text('Username: ${userProfile['username'] ?? 'N/A'}'),
              Text('Email: ${userProfile['useremail'] ?? 'N/A'}'),
            ],
          );
        },
      ),
    );
  }
}
