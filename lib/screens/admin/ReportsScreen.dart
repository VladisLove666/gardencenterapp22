import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отчеты')),
      body: Center(
        child: Text('Здесь будут отчеты по продажам и пользователям.'),
      ),
    );
  }
}