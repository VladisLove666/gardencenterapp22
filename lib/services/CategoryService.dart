import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardencenterapppp/models/Category.dart';

class CategoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Category>> getAll() async {
    final data = await _supabase.from('categories').select('*');
    return data.map((e) => Category.fromJson(e)).toList();
  }

  Future<void> create(Category category) async {
    await _supabase.from('categories').insert(category.toJson());
  }

  Future<void> update(Category category) async {
    await _supabase.from('categories').update(category.toJson()).eq('id', category.id);
  }

  Future<void> delete(String id) async {
    await _supabase.from('categories').delete().eq('id', id);
  }
}