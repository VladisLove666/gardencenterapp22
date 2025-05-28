import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ProductService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<List<Product>> getProducts() async {
    final response = await client.from('products').select().execute();
    if (response.error == null) {
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    }
    return [];
  }

  static Future<Product?> getProductById(String productId) async {
    final response = await client.from('products').select().eq('id', productId).single().execute();
    if (response.error == null) {
      return Product.fromJson(response.data);
    }
    return null;
  }
}

extension on PostgrestTransformBuilder<PostgrestMap> {
  Future execute() async {}
}

extension on PostgrestFilterBuilder<PostgrestList> {
  Future execute() async {}
}