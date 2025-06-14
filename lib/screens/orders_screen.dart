import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/order.dart';
import 'package:gardencenterapppp/services/order_service.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:gardencenterapppp/screens/OrderDetailScreen.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user!.id; // Получаем ID пользователя

    return Scaffold(
      appBar: AppBar(
        title: const Text('История заказов'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<List<Order>>(
        future: OrderService().getAllOrders(userId), // Передаем userId в сервис
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Нет заказов.'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              // Создаем номер заказа
              String orderNumber = 'Заказ #${index + 1} от ${order.createdAt.toLocal().toString().split(' ')[0]}'; // Форматируем дату

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    orderNumber,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ), // Отображаем номер заказа
                  subtitle: Text(
                    'Статус: ${order.status}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onTap: () {
                    // Переход к экрану деталей заказа
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderDetailScreen(orderId: order.id)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}