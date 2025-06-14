import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/user.dart';
import 'package:gardencenterapppp/services/UserService.dart';


class EditUserScreen extends StatefulWidget {
  final User user;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    phoneController.text = widget.user.phone;
    emailController.text = widget.user.email;
  }

  Future<void> _saveUser() async {
    final updatedUser = User(
      id: widget.user.id,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phone: phoneController.text,
      email: emailController.text,
      role: widget.user.role, // Предполагается, что роль не меняется
      isBanned: widget.user.isBanned,
    );

    await UserService().update(updatedUser);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать пользователя'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Фамилия'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Телефон'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUser,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}