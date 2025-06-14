import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/OrderItem.dart';
import 'package:gardencenterapppp/models/order.dart';
import 'package:gardencenterapppp/services/order_service.dart';

class EditOrderScreen extends StatefulWidget {
  final Order order;

  EditOrderScreen({required this.order});

  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late Future<List<OrderItem>> _orderItemsFuture;
  final TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orderItemsFuture = OrderService().getOrderItems(widget.order.id);
    statusController.text = widget.order.status; // Инициализация поля статуса
  }

  Future<void> _saveOrder() async {
    // Обновляем статус заказа
    final updatedOrder = Order(
      id: widget.order.id,
      userId: widget.order.userId,
      status: statusController.text,
      createdAt: widget.order.createdAt,
    );

    await OrderService().update(updatedOrder);
    Navigator.pop(context);
  }

  Future<void> _deleteOrderItem(String orderItemId) async {
    await OrderService().deleteOrderItem(orderItemId); // Метод для удаления товара из заказа
    setState(() {
      _orderItemsFuture = OrderService().getOrderItems(widget.order.id); // Обновляем список товаров
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать заказ ${widget.order.id}'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: _orderItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет товаров в заказе.'));
          }

          final orderItems = snapshot.data!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'Статус заказа'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: orderItems.length,
                  itemBuilder: (context, index) {
                    final orderItem = orderItems[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text('Товар: ${orderItem.productName}'), // Отображаем имя товара
                        subtitle: Row(
                          children: [
                            Text('Количество: ${orderItem.quantity}'),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteOrderItem(orderItem.id); // Удаляем товар из заказа
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveOrder,
        child: Icon(Icons.save),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}