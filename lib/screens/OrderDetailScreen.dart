import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/OrderItem.dart';
import 'package:gardencenterapppp/services/order_service.dart';
import 'package:gardencenterapppp/services/product_service.dart';
import 'package:gardencenterapppp/models/product.dart';
import 'package:gardencenterapppp/models/order.dart'; // Импортируйте модель Order

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  OrderDetailScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<Order>(
        future: OrderService().getOrderById(orderId), // Получаем заказ по ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Нет данных о заказе.'));
          }

          final order = snapshot.data!;

          return FutureBuilder<List<OrderItem>>(
            future: OrderService().getOrderItems(orderId), // Получаем товары из заказа
            builder: (context, itemSnapshot) {
              if (itemSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (itemSnapshot.hasError) {
                return Center(child: Text('Ошибка: ${itemSnapshot.error}'));
              }
              if (!itemSnapshot.hasData || itemSnapshot.data!.isEmpty) {
                return Center(child: Text('Нет товаров в заказе.'));
              }

              final items = itemSnapshot.data!;
              double totalPrice = 0.0; // Переменная для общей стоимости

              // Вычисляем общую стоимость
              for (int index = 0; index < items.length; index++) {
                final item = items[index];
                totalPrice += item.price * item.quantity; // Суммируем стоимость
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Имя получателя: ${order.recipientName ?? "Не указано"}', // Отображаем имя получателя
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Адрес доставки: ${order.address ?? "Не указан"}', // Отображаем адрес
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
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
          );
        },
      ),
    );
  }
}