import 'package:gardencenterapppp/models/OrderItem.dart';
import 'package:gardencenterapppp/models/RevenueStatistics.dart';
import 'package:gardencenterapppp/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardencenterapppp/models/order.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Order>> getAll() async {
    final data = await _supabase.from('orders').select('*');
    return data.map((e) => Order.fromJson(e)).toList();
  }

  Future<Order> getOrderById(String orderId) async {
    final data = await _supabase
        .from('orders')
        .select('*, users(first_name, last_name)') // Извлекаем имя и фамилию пользователя
        .eq('id', orderId)
        .single();

    // Получаем имя получателя
    String? recipientName;
    if (data['users'] != null) {
      recipientName = '${data['users']['first_name']} ${data['users']['last_name']}';
    }

    // Создаем объект Order с именем получателя и адресом
    return Order(
      id: data['id'],
      userId: data['user_id'],
      status: data['status'],
      createdAt: DateTime.parse(data['created_at']),
      address: data['address'], // Убедитесь, что адрес извлекается
      recipientName: recipientName, // Устанавливаем имя получателя
    );
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await Supabase.instance.client.from('orders').update({
      'status': newStatus,
    }).eq('id', orderId);
  }

  Future<List<Order>> getAllOrders(String userId) async {
    final data = await _supabase
        .from('orders')
        .select('*')
        .eq('user_id', userId);

    return data.map((e) => Order.fromJson(e)).toList();
  }

  Future<void> deleteOrderItem(String orderItemId) async {
    await Supabase.instance.client.from('order_items').delete().eq('id', orderItemId);
  }

  Future<List<OrderItem>> getOrderItems(String orderId) async {
    final data = await _supabase
        .from('order_items')
        .select('*, products(*)')
        .eq('order_id', orderId);

    return data.map((item) => OrderItem.fromJson(item)).toList();
  }

  Future<void> updateOrderItemQuantity(String orderItemId, int newQuantity) async {
    await Supabase.instance.client.from('order_items').update({
      'quantity': newQuantity,
    }).eq('id', orderItemId);
  }

  Future<void> createOrder(String userId, String productId) async {
    try {
      // Создаем новый заказ
      final order = Order(
        userId: userId,
        status: 'в корзине',
        createdAt: DateTime.now(),
        id: '',
      );

      // Вставляем заказ в базу данных и получаем его ID
      final response = await _supabase.from('orders').insert(order.toJson()).select().single();
      final orderId = response['id'];

      // Получаем информацию о продукте, включая цену
      final productResponse = await _supabase
          .from('products')
          .select('price')
          .eq('id', productId)
          .single();

      final double productPrice = productResponse['price']; // Получаем цену продукта

      // Создаем элемент заказа с полученной ценой
      final orderItem = OrderItem(
        orderId: orderId,
        productId: productId,
        quantity: 1,
        id: '',
        productName: '', // Здесь можно добавить логику для получения имени продукта, если нужно
        price: productPrice, // Передаем цену продукта
      );

      // Вставляем элемент заказа в базу данных
      await _supabase.from('order_items').insert(orderItem.toJson());
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
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

  Future<RevenueStatistics> getRevenueStatistics() async {
    final response = await _supabase
        .from('orders')
        .select('''
            SUM(CASE WHEN created_at >= CURRENT_DATE THEN total_amount ELSE 0 END) AS daily_revenue,
            SUM(CASE WHEN created_at >= date_trunc('month', CURRENT_DATE) THEN total_amount ELSE 0 END) AS monthly_revenue,
            SUM(CASE WHEN created_at >= date_trunc('year', CURRENT_DATE) THEN total_amount ELSE 0 END) AS yearly_revenue
        ''')
        .single();

    return RevenueStatistics.fromMap(response);
  }
}