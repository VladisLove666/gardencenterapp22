import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/order.dart';
import 'package:gardencenterapppp/services/cart_service.dart';

class PaymentScreen extends StatefulWidget {
  final Order order;

  PaymentScreen({required this.order});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _paymentMethod;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();

  void _submitOrder() async {
    // Обновляем адрес в заказе
    widget.order.address = _addressController.text;

    // Здесь вы можете добавить логику для обработки платежа
    // Например, если выбран способ оплаты картой, вы можете выполнить проверку карты

    await CartService().checkout(widget.order.userId, widget.order.address!); // Передаем адрес
    Navigator.pop(context); // Возвращаемся на предыдущий экран
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выбор способа оплаты'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Выберите способ оплаты:'),
            ListTile(
              title: Text('Картой'),
              leading: Radio<String>(
                value: 'card',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Наличными'),
              leading: Radio<String>(
                value: 'cash',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            if (_paymentMethod == 'card') ...[
              TextField(
                controller: _cardNumberController,
                decoration: InputDecoration(labelText: 'Номер карты'),
              ),
            ],
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Адрес доставки'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitOrder,
              child: Text('Подтвердить заказ'),
            ),
          ],
        ),
      ),
    );
  }
}