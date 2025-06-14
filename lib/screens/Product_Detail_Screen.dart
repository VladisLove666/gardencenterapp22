import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/product.dart';
import 'package:gardencenterapppp/services/cart_service.dart';
import 'package:provider/provider.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              product.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Цена: ${product.price} ₽',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[700]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final userId = Provider.of<AuthProvider>(context, listen: false).user!.id;
                try {
                  await CartService().addToCart(userId, product.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Товар добавлен в корзину')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.black,// Цвет кнопки
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Добавить в корзину'),
            ),
          ],
        ),
      ),
    );
  }
}