import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.auth.signIn(
      email: emailController.text,
      password: passwordController.text,
    );

    if (response.error == null) {
      final userId = response.user!.id;

      // استعلام للحصول على معلومات الدور
      final profileResponse = await supabase
          .from('profiles')
          .select('role_id')
          .eq('id', userId)
          .single();

      if (profileResponse.error == null) {
        final roleId = profileResponse.data['role_id'];
        if (roleId == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserPage(userId: userId)),
          );
        }
      }
    } else {
      print('Error logging in: ${response.error!.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
