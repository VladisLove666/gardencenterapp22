import 'package:flutter/material.dart';

class DeliveryDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Детали доставки')),
      body: Center(
        child: Text('Здесь будут детали доставки.'),
      ),
    );
  }
}