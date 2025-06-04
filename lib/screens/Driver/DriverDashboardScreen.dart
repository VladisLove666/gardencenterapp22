import 'package:flutter/material.dart';

class DriverDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Панель водителя')),
      body: Center(
        child: Text('Добро пожаловать, водитель!'),
      ),
    );
  }
}