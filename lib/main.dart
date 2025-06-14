import 'package:flutter/material.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';
import 'package:gardencenterapppp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ypvngvpshbnrkdodcvxx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlwdm5ndnBzaGJucmtkb2Rjdnh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0MDk2MDgsImV4cCI6MjA2Mjk4NTYwOH0.w_HOeKDNJFHp2bWxGkIq7v8bfvoqpelY5yeCcPP0ZnQ',
  );

  final userId = await AuthService().getUserState();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String? initialUserId;
  MyApp({this.initialUserId});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Садовый Центр',
        theme: ThemeData(primarySwatch: Colors.green),
        home: LoginScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}