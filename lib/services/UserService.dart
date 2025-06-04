import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:gardencenterapppp/models/user.dart';

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<User>> getAll() async {
    final data = await _supabase.from('users').select('*');
    return data.map((e) => User.fromJson(e)).toList();
  }

  Future<void> update(User user) async {
    await _supabase.from('users').update(user.toJson()).eq('id', user.id);
  }

  Future<void> delete(String id) async {
    await _supabase.from('users').delete().eq('id', id);
  }
}