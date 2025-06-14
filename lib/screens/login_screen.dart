import 'package:flutter/material.dart';
import 'package:gardencenterapppp/screens/Driver/DriverMainScreen.dart';
import 'package:gardencenterapppp/screens/MainNavigation_Screen.dart';
import 'package:gardencenterapppp/screens/admin/admin_main_screen.dart';
import 'package:gardencenterapppp/screens/manager/ManagerMainScreen.dart';
import 'package:gardencenterapppp/screens/registration_screen.dart';
import 'package:gardencenterapppp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Добро пожаловать!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Валидация ввода
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Пожалуйста, заполните все поля.')));
                    return;
                  }

                  // Проверка формата email
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Введите корректный email.')));
                    return;
                  }

                  try {
                    await AuthService().signIn(emailController.text, passwordController.text);
                    final user = await AuthService().getMe();
                    Provider.of<AuthProvider>(context, listen: false).setUser(user);

                    // Навигация в зависимости от роли
                    if (user!.role.name == 'admin') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminMainScreen()));
                    } else if (user.role.name == 'manager') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerMainScreen()));
                    } else if (user.role.name == 'driver') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DriverMainScreen()));
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigationScreen()));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Войти'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()), // Navigate to RegisterScreen
                  );
                },
                child: Text(
                  'Нет аккаунта? Зарегистрируйтесь',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}