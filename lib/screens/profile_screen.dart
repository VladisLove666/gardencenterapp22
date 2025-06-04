import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/user.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Имя: ${user.firstName} ${user.lastName}'),
            Text('Телефон: ${user.phone}'),
            Text('Email: ${user.email}'),
            ElevatedButton(
              onPressed: () {
                // Navigate to EditProfileScreen
              },
              child: Text('Редактировать профиль'),
            ),
          ],
        ),
      ),
    );
  }
}