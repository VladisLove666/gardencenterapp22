import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class AuthService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<bool> login(String phone, String password) async {
    final response = await client.auth.signInWithPassword(
      phone: phone,
      password: password,
    );

    // Check if the user is authenticated
    return response.user != null;
  }

  static Future<bool> register(String firstName, String lastName, String phone, String password) async {
    final response = await client.auth.signUp(
      phone: phone,
      password: password,
    );

    // Check if the user is created successfully
    if (response.user != null) {
      await client.from('users').insert({
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'password': password, // Не храните пароль в базе данных!
        'balance': 0,
      });
      return true;
    }
    return false;
  }
}