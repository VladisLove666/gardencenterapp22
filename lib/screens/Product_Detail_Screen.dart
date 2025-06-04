import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(product.description),
            SizedBox(height: 20),
            Text('${product.price} ₽'),
            ElevatedButton(
              onPressed: () {
                // Add to cart logic
              },
              child: Text('Добавить в корзину'),
            ),
          ],
        ),
      ),
    );
  }
}