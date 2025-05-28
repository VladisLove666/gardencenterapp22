import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen(productId: product.id)),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.description),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('\${product.price.toStringAsFixed(2)}'),
            ),
            ElevatedButton(
              onPressed: () {
                // Добавить в корзину
              },
              child: Text('Добавить в корзину'),
            ),
          ],
        ),
      ),
    );
  }
}