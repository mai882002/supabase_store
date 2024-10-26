import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> signUp() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.auth.signUp(
      email: emailController.text,
      password: passwordController.text,
    );

    if (response.error == null) {
      final userId = response.user!.id;

      // رفع صورة الملف الشخصي إلى Supabase
      if (_imageFile != null) {
        final fileName = _imageFile!.name;
        final fileResponse = await supabase.storage
            .from('avatars')
            .upload(fileName, File(_imageFile!.path));
        if (fileResponse.error == null) {
          final avatarUrl =
              supabase.storage.from('avatars').getPublicUrl(fileName);

          // إدخال بيانات المستخدم في جدول profiles
          await createProfile(userId, avatarUrl);
        }
      }
    }
  }

  Future<void> createProfile(String userId, String avatarUrl) async {
    final supabase = Supabase.instance.client;

    await supabase.from('profiles').insert({
      'id': userId,
      'username': 'hana', // يمكنك استخدام قيمة من واجهة المستخدم
      'useremail': emailController.text,
      'avatar_url': avatarUrl,
      'role_id': 2, // افتراض أن 2 هو دور 'user'
    }).execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
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
              onPressed: pickImage,
              child: Text('Pick Profile Image'),
            ),
            _imageFile != null
                ? Image.file(File(_imageFile!.path))
                : Container(),
            ElevatedButton(
              onPressed: signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
