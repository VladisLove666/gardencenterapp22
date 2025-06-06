import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/order.dart';
import 'package:gardencenterapppp/services/order_service.dart';
import 'package:provider/provider.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user!.id;

    return Scaffold(
      appBar: AppBar(title: const Text('История заказов')),
      body: FutureBuilder<List<Order>>(
        future: OrderService().getOrderHistory(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет заказов.'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Заказ ${order.id}'),
                subtitle: Text('Статус: ${order.status}'),
                onTap: () {
                  // Navigate to OrderDetailScreen
                },
              );
            },
          );
        },
      ),
    );
  }
}