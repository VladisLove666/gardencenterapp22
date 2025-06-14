import 'package:flutter/material.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';
import 'package:gardencenterapppp/screens/driver/DriverOrdersScreen.dart'; // Экран заказов водителя
import 'package:gardencenterapppp/screens/profile_screen.dart'; // Экран профиля
import 'package:provider/provider.dart';

class DriverMainScreen extends StatefulWidget {
  @override
  _DriverMainScreenState createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DriverOrdersScreen(), // Экран заказов
    SizedBox.shrink(), // Экран профиля
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    _screens[1] = ProfileScreen(user: user!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Водитель'),
        backgroundColor: Colors.green[700],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Заказы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700], // Цвет выделенного элемента
        unselectedItemColor: Colors.grey, // Цвет для невыделенных элементов
        backgroundColor: Colors.white, // Цвет фона нижней навигации
        elevation: 5, // Эффект тени для нижней навигации
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}