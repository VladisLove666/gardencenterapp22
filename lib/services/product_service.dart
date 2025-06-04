import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardencenterapppp/models/product.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Product>> getAll() async {
    final data = await _supabase.from('products').select('*');
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<void> create(Product product) async {
    await _supabase.from('products').insert(product.toJson());
  }

  Future<void> update(Product product) async {
    await _supabase.from('products').update(product.toJson()).eq('id', product.id);
  }

  Future<void> delete(String id) async {
    await _supabase.from('products').delete().eq('id', id);
  }
}