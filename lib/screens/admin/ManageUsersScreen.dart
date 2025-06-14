import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/user.dart';
import 'package:gardencenterapppp/screens/admin/EditUserScreen.dart';
import 'package:gardencenterapppp/services/UserService.dart';

class ManageUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление пользователями'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<List<User>>(
        future: UserService().getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет доступных пользователей.'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  title: Text('${user.firstName} ${user.lastName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(user.email, style: TextStyle(color: Colors.grey[600])),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditUserScreen(user: user)),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}