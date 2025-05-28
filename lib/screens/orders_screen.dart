import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';

class OrdersScreen extends StatelessWidget {
  final String userId;

  const OrdersScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заказы')),
      body: FutureBuilder<List<Order>>(
        future: OrderService.getOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки заказов'));
          }
          final orders = snapshot.data ?? [];

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Заказ #${orders[index].id}'),
                subtitle: Text('Статус: ${orders[index].status}'),
              );
            },
          );
        },
      ),
    );
  }
}