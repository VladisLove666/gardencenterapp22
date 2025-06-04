import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('${product.price} ₽'),
        onTap: () {
          // Navigate to ProductDetailScreen
        },
      ),
    );
  }
}