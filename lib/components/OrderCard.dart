import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Заказ ${order.id}'),
        subtitle: Text('Статус: ${order.status}'),
        onTap: () {
          // Navigate to OrderDetailScreen
        },
      ),
    );
  }
}