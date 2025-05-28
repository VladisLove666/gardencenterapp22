import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order.dart';

class OrderService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<List<Order>> getOrders(String userId) async {
    final response = await client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .execute();

    if (response.error == null) {
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      // Обработка ошибки
      print('Error fetching orders: ${response.error!.message}');
      return [];
    }
  }
}

extension on PostgrestFilterBuilder<PostgrestList> {
  Future execute() async {}
}