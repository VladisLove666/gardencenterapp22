import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ypvngvpshbnrkdodcvxx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlwdm5ndnBzaGJucmtkb2Rjdnh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0MDk2MDgsImV4cCI6MjA2Mjk4NTYwOH0.w_HOeKDNJFHp2bWxGkIq7v8bfvoqpelY5yeCcPP0ZnQ',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Садовый Центр',
      theme: ThemeData(primarySwatch: Colors.green),
      home: LoginScreen(),
    );
  }
}