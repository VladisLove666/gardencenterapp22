import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final int quantity;

  const CartItem({Key? key, required this.product, required this.quantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('Количество: $quantity'),
      trailing: Text('\${(product.price * quantity).toStringAsFixed(2)}'),
    );
  }
}