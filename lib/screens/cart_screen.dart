import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/CartItem.dart';
import 'package:gardencenterapppp/models/cart.dart';
import 'package:gardencenterapppp/models/order.dart';
import 'package:gardencenterapppp/models/product.dart';
import 'package:gardencenterapppp/screens/PaymentScreen.dart';
import 'package:gardencenterapppp/services/cart_service.dart';
import 'package:gardencenterapppp/services/product_service.dart';
import 'package:provider/provider.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Cart?> _cartFuture;
  List<CartItem>? _cartItems; // Список для хранения товаров в корзине

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<AuthProvider>(context, listen: false).user!.id;
    _cartFuture = CartService().getCart(userId); // Инициализируем Future
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<Cart?>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Корзина пуста.'));
          }

          final cart = snapshot.data!;
          return FutureBuilder<List<CartItem>>(
            future: CartService().getCartItems(cart.id),
            builder: (context, itemSnapshot) {
              if (itemSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (itemSnapshot.hasError) {
                return Center(child: Text('Ошибка: ${itemSnapshot.error}'));
              }
              if (!itemSnapshot.hasData || itemSnapshot.data!.isEmpty) {
                return Center(child: Text('Нет товаров в корзине.'));
              }

              _cartItems = itemSnapshot.data!; // Сохраняем товары в корзине

              return FutureBuilder<List<Product>>(
                future: Future.wait(_cartItems!.map((item) => ProductService().getProductById(item.productId))),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (productSnapshot.hasError) {
                    return Center(child: Text('Ошибка: ${productSnapshot.error}'));
                  }
                  if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                    return Center(child: Text('Нет товаров в корзине.'));
                  }

                  final products = productSnapshot.data!;

                  // Подсчет общей стоимости
                  double totalPrice = 0.0;
                  for (int index = 0; index < _cartItems!.length; index++) {
                    final item = _cartItems![index];
                    final product = products.firstWhere((p) => p.id == item.productId);
                    totalPrice += product.price * item.quantity; // Суммируем стоимость
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _cartItems!.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems![index];
                            final product = products.firstWhere((p) => p.id == item.productId); // Находим продукт по ID

                            return Card(
                              margin: EdgeInsets.all(10),
                              elevation: 5,
                              child: ListTile(
                                title: Text('Товар: ${product.name}', style: TextStyle(fontSize: 16)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Количество: ${item.quantity}', style: TextStyle(color: Colors.grey[600])),
                                    Text('Цена за единицу: ${product.price} ₽', style: TextStyle(color: Colors.grey[600])),
                                    Text('Итого: ${(product.price * item.quantity).toStringAsFixed(2)} ₽', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () async {
                                        await CartService().decreaseQuantity(item.id);
                                        _refreshCart(); // Обновляем корзину
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () async {
                                        await CartService().increaseQuantity(item.id);
                                        _refreshCart(); // Обновляем корзину
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        await CartService().removeFromCart(item.id);
                                        _refreshCart(); // Обновляем корзину
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Общая стоимость: ${totalPrice.toStringAsFixed(2)} ₽', // Форматируем общую стоимость
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Получаем текущую корзину
          final cart = await CartService().getCart(userId); // userId - это ID текущего пользователя
          if (cart != null) {
            // Создаем новый заказ
            final order = Order(
              userId: userId,
              status: 'выполняется',
              createdAt: DateTime.now(),
              address: '', // Здесь можно оставить пустым, адрес будет введен на следующем экране
            );

            // Открываем экран выбора способа оплаты
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentScreen(order: order)), // Передаем созданный заказ
            );
          } else {
            // Обработка случая, когда корзина не найдена
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Корзина пуста.')));
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.black,
      ),
    );
  }

  void _refreshCart() {
    setState(() {
      // Обновляем Future для корзины
      final userId = Provider.of<AuthProvider>(context, listen: false).user!.id;
      _cartFuture = CartService().getCart(userId);
    });
  }
}