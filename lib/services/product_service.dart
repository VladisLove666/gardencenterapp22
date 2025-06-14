import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardencenterapppp/models/product.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Product>> getAll() async {
    final data = await _supabase.from('products').select('*');
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> getAllByCategory(String categoryId) async {
    final data = await _supabase
        .from('products')
        .select('*')
        .eq('category_id', categoryId); // Fetch products by category ID
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> getProductById(String productId) async {
    final data = await _supabase
        .from('products')
        .select('*')
        .eq('id', productId)
        .single();

    return Product.fromJson(data);
  }

  Future<void> createProduct(Product product) async {
    await _supabase.from('products').insert(product.toJson());
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

  Future<int> getTotalStock() async {
    final response = await _supabase
        .from('products')
        .select('sum(stock)') // Получаем сумму всех товаров на складе
        .single();

    return response['sum'] ?? 0; // Возвращаем общее количество на складе или 0, если данных нет
  }
}