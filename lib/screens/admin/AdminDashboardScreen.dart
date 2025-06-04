import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Админка')),
      body: Center(
        child: Text('Добро пожаловать в админку!'),
      ),
    );
  }
}