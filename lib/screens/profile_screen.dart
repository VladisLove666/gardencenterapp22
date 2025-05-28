import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String phone;

  const ProfileScreen({Key? key, required this.firstName, required this.lastName, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Имя: $firstName', style: TextStyle(fontSize: 20)),
            Text('Фамилия: $lastName', style: TextStyle(fontSize: 20)),
            Text('Номер телефона: $phone', style: TextStyle(fontSize: 20)),
            // Добавьте возможность редактирования информации
          ],
        ),
      ),
    );
  }
}