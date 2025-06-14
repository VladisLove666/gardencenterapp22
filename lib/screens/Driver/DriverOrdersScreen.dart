import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/order.dart';
import 'package:gardencenterapppp/screens/OrderDetailScreen.dart';
import 'package:gardencenterapppp/services/order_service.dart';

class DriverOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы водителя'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<List<Order>>(
        future: OrderService().getAll(), // Получаем все заказы
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет доступных заказов.'));
          }

          final orders = snapshot.data!;

          // Фильтруем заказы, исключая завершённые и отменённые
          final filteredOrders = orders.where((order) => order.status != 'завершен' && order.status != 'отменен').toList();

          if (filteredOrders.isEmpty) {
            return const Center(child: Text('Нет доступных заказов.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  title: Text('Заказ #${index + 1}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Статус: ${order.status}', style: TextStyle(color: Colors.grey[600])),
                  trailing: DropdownButton<String>(
                    value: order.status,
                    items: <String>['выполняется', 'В пути', 'завершен', 'отменен']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _updateOrderStatus(order.id, newValue);
                      }
                    },
                  ),
                  onTap: () {
                    // Переход на экран деталей заказа
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

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    await OrderService().updateOrderStatus(orderId, newStatus);
  }
}