import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Корзина')),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return CartItem(product: cartItems[index], quantity: 1); // Замените 1 на реальное количество
        },
      ),
    );
  }
}