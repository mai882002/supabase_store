import 'package:flutter/material.dart';
import 'package:mai_store_ecommerce/screen/Homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vuagprclhrupuinezhva.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1YWdwcmNsaHJ1cHVpbmV6aHZhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk1MzE5NDksImV4cCI6MjA0NTEwNzk0OX0.gA-QDURt0VoMpnZWAJcZocX69lcf_VBn1HqDMzmBjKs',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Supabase',
      home: HomePage(),
    );
  }
}
