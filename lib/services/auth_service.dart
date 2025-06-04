import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardencenterapppp/models/user.dart' as user;

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(String firstName, String email, String phone, String password) async {
    await _supabase.auth.signUp(email: email, password: password, data: {
      'firstName': firstName,
      'phone': phone,
    });
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<user.User?> getMe() async {
    final currentUser = _supabase.auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    final data = await _supabase
        .from('users')
        .select('*, roles(*)')
        .eq('id', currentUser.id)
        .single();

    return user.User.fromJson(data);
  }
}