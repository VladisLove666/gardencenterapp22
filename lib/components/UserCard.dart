import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/user.dart';

class UserCard extends StatelessWidget {
  final User user;

  UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(user.email),
        onTap: () {
          // Navigate to UserDetailScreen
        },
      ),
    );
  }
}