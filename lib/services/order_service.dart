import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardencenterapppp/models/order.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Order>> getAll() async {
    final data = await _supabase.from('orders').select('*');
    return data.map((e) => Order.fromJson(e)).toList();
  }

  Future<void> create(Order order) async {
    await _supabase.from('orders').insert(order.toJson());
  }

  Future<void> update(Order order) async {
    await _supabase.from('orders').update(order.toJson()).eq('id', order.id);
  }

  Future<void> delete(String id) async {
    await _supabase.from('orders').delete().eq('id', id);
  }

  Future<List<Order>> getOrderHistory(String userId) async {
    final data = await _supabase
        .from('orders')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return data.map((e) => Order.fromJson(e)).toList();
  }


  Future<List<Order>> getCartOrders(String userId) async {
    final data = await _supabase
        .from('orders')
        .select('*')
        .eq('user_id', userId)
        .eq('status', 'в корзине')
        .order('created_at', ascending: false);

    return data.map((e) => Order.fromJson(e)).toList();
  }
}