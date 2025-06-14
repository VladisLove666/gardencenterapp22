import 'package:flutter/material.dart';
import 'package:gardencenterapppp/screens/home_screen.dart';
import 'package:gardencenterapppp/screens/cart_screen.dart';
import 'package:gardencenterapppp/screens/orders_screen.dart';
import 'package:gardencenterapppp/screens/profile_screen.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CartScreen(),
    OrderHistoryScreen(),
    SizedBox.shrink(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    _screens[3] = ProfileScreen(user: user!);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Витрина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
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
        selectedItemColor: Colors.green[700], // Highlight color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        backgroundColor: Colors.white, // Background color of the BottomNavigationBar
        elevation: 5, // Shadow effect for the BottomNavigationBar
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Fixed type for better layout
      ),
    );
  }
}