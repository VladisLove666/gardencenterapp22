import 'package:flutter/material.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';
import 'package:gardencenterapppp/screens/admin/ManageProductsScreen.dart';
import 'package:gardencenterapppp/screens/manager/OrderOverviewScreen.dart';
import 'package:gardencenterapppp/screens/manager/RevenueStatisticsScreen.dart';
import 'package:gardencenterapppp/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class ManagerMainScreen extends StatefulWidget {
  @override
  _ManagerMainScreenState createState() => _ManagerMainScreenState();
}

class _ManagerMainScreenState extends State<ManagerMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    OrderOverviewScreen(),
    ManageProductsScreen(),
    RevenueStatisticsScreen(),
    SizedBox.shrink(), // Место для дополнительного экрана, если нужно
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    _screens[3] = ProfileScreen(user: user!); // Профиль пользователя
    return Scaffold(
      appBar: AppBar(
        title: const Text('Менеджер'),
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
            icon: Icon(Icons.shopping_cart),
            label: 'Товары',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Статистика выручки',
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