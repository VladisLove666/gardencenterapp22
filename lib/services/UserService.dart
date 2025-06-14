import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:gardencenterapppp/models/user.dart';

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;


  Future<User?> getCurrentUser() async {
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      return null; // Если пользователь не авторизован
    }

    final data = await _supabase
        .from('users')
        .select('*, roles(name)') // Получаем имя роли
        .eq('id', currentUser.id)
        .single();

    return User.fromJson(data); // Возвращаем объект User
  }

  Future<List<User>> getAll() async {
    final data = await _supabase.from('users').select('*');
    print(data);
    return data.map((e) => User.fromJson(e)).toList();
  }

  Future<void> update(User user) async {
    await _supabase.from('users').update(user.toJson()).eq('id', user.id);
  }

  Future<void> delete(String id) async {
    await _supabase.from('users').delete().eq('id', id);
  }
}