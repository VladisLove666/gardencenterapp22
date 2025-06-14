import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardencenterapppp/models/user.dart' as user;

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    // Логика входа
    await _supabase.auth.signInWithPassword(email: email, password: password);

    // Сохраните ID пользователя
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await saveUserState(user.id);
    }
  }

  Future<void> saveUserState(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String?> getUserState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> signUp(String firstName, String lastName, String email, String phone, String password) async {
    // Фиксированный ID роли "user"
    final String roleId = '4dc6ee0a-c0af-4fa6-920d-2a7d21c41f6b';

    // Регистрация пользователя в Supabase
    final response = await _supabase.auth.signUp(email: email, password: password, data: {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    });

    // Получаем ID нового пользователя
    final userId = response.user?.id;

    if (userId != null) {
      // Вставляем данные в вашу таблицу пользователей
      await _supabase.from('users').insert({
        'id': userId, // Используем ID из Supabase
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'password': password, // Добавляем пароль
        'role_id': roleId, // Присваиваем фиксированный ID роли "user"
        'is_banned': false, // Устанавливаем статус по умолчанию
      });
    } else {
      throw Exception('Не удалось получить ID пользователя после регистрации.');
    }
  }

  Future<void> changePassword(String newPassword) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } else {
      throw Exception('Пользователь не авторизован');
    }
  }

  // Метод для выхода
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); // Удаляем сохраненное состояние
    await _supabase.auth.signOut(); // Выход из Supabase
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