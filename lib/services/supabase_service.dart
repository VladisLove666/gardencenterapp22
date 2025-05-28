import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = SupabaseClient(
    'https://ypvngvpshbnrkdodcvxx.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlwdm5ndnBzaGJucmtkb2Rjdnh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0MDk2MDgsImV4cCI6MjA2Mjk4NTYwOH0.w_HOeKDNJFHp2bWxGkIq7v8bfvoqpelY5yeCcPP0ZnQ',
  );

  static Future<void> init() async {
    try {
      await Supabase.initialize(
        url: 'https://ypvngvpshbnrkdodcvxx.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlwdm5ndnBzaGJucmtkb2Rjdnh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0MDk2MDgsImV4cCI6MjA2Mjk4NTYwOH0.w_HOeKDNJFHp2bWxGkIq7v8bfvoqpelY5yeCcPP0ZnQ',
      );
    } catch (e) {
      print('Error initializing Supabase: $e');
    }
  }
}