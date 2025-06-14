import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/OrderItem.dart';
import 'package:gardencenterapppp/services/order_service.dart';

class OrderItemsScreen extends StatelessWidget {
  final String orderId;

  OrderItemsScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: OrderService().getOrderItems(orderId), // Получаем товары из заказа
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Нет товаров в заказе.'));
          }

          final items = snapshot.data!;
          double totalPrice = 0.0; // Переменная для общей стоимости

          // Отладка: выводим информацию о товарах
          for (var item in items) {
            print('Product: ${item.productName}, Price: ${item.price}, Quantity: ${item.quantity}');
            totalPrice += item.price * item.quantity; // Добавляем к общей стоимости
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    double itemTotalPrice = item.price * item.quantity; // Общая цена для позиции

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text(item.productName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text('Количество: ${item.quantity} - Цена: ${item.price} ₽\nИтого: ${itemTotalPrice} ₽', style: TextStyle(color: Colors.grey[600])),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Общая стоимость: ${totalPrice.toStringAsFixed(2)} ₽', // Форматируем общую стоимость
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}