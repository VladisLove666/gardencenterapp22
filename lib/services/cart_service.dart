import 'package:gardencenterapppp/models/CartItem.dart';
import 'package:gardencenterapppp/models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gardencenterapppp/models/cart.dart';

class CartService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Cart?> getCart(String userId) async {
    final response = await _supabase
        .from('carts')
        .select('*')
        .eq('user_id', userId)
        .maybeSingle();

    return response != null ? Cart.fromJson(response) : null;
  }

  Future<void> increaseQuantity(String cartItemId) async {
    // Fetch the current quantity
    final response = await _supabase
        .from('cart_items')
        .select('quantity')
        .eq('id', cartItemId)
        .single();

    if (response != null) {
      int currentQuantity = response['quantity'];
      // Increase the quantity
      await _supabase.from('cart_items').update({
        'quantity': currentQuantity + 1
      }).eq('id', cartItemId);
    }
  }

  Future<void> decreaseQuantity(String cartItemId) async {
    // Fetch the current quantity
    final response = await _supabase
        .from('cart_items')
        .select('quantity')
        .eq('id', cartItemId)
        .single();

    if (response != null) {
      int currentQuantity = response['quantity'];
      if (currentQuantity > 1) {
        // Decrease the quantity
        await _supabase.from('cart_items').update({
          'quantity': currentQuantity - 1
        }).eq('id', cartItemId);
      } else {
        // If quantity is 1, remove the item from the cart
        await removeFromCart(cartItemId);
      }
    }
  }

  Future<List<CartItem>> getCartItems(String cartId) async {
    final data = await _supabase
        .from('cart_items')
        .select('*, products(*)')
        .eq('cart_id', cartId);

    return data.map((item) => CartItem.fromJson(item)).toList();
  }

  Future<void> addToCart(String userId, String productId) async {
    Cart? cart = await getCart(userId);
    if (cart == null) {
      cart = Cart(id: '', userId: userId, createdAt: DateTime.now());
      final response = await _supabase.from('carts').insert(cart.toJson()).select().single();
      cart.id = response['id'];
    }

    final existingItem = await _supabase
        .from('cart_items')
        .select('*')
        .eq('cart_id', cart.id)
        .eq('product_id', productId)
        .maybeSingle();

    if (existingItem != null) {
      // Увеличиваем количество
      await _supabase.from('cart_items').update({
        'quantity': existingItem['quantity'] + 1
      }).eq('id', existingItem['id']);
    } else {
      // Добавляем новый товар в корзину
      await _supabase.from('cart_items').insert({
        'cart_id': cart.id,
        'product_id': productId,
        'quantity': 1,
      });
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    await _supabase.from('cart_items').delete().eq('id', cartItemId);
  }

  Future<void> checkout(String userId, String address) async {
    Cart? cart = await getCart(userId);

    if (cart == null) {
      throw Exception('Корзина не найдена для пользователя $userId');
    }

    // Создаем новый заказ
    final order = Order(
      id: '',
      userId: userId,
      status: 'выполняется',
      createdAt: DateTime.now(),
      address: address, // Устанавливаем адрес
    );

    // Вставляем заказ в базу данных и получаем его ID
    final orderResponse = await _supabase.from('orders').insert(order.toJson()).select().single();
    final orderId = orderResponse['id'];

    // Получаем товары из корзины
    final cartItems = await getCartItems(cart.id);
    for (var item in cartItems) {
      await _supabase.from('order_items').insert({
        'order_id': orderId,
        'product_id': item.productId,
        'quantity': item.quantity,
      });
    }

    // Удаляем все товары из корзины
    await _supabase.from('cart_items').delete().eq('cart_id', cart.id);
  }
}