import 'package:flutter/material.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';
import 'package:gardencenterapppp/screens/admin/ManageCategoriesScreen.dart';
import 'package:gardencenterapppp/screens/admin/ManageOrdersScreen.dart';
import 'package:gardencenterapppp/screens/admin/ManageProductsScreen.dart';
import 'package:gardencenterapppp/screens/admin/ManageUsersScreen.dart';
import 'package:gardencenterapppp/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class AdminMainScreen extends StatefulWidget {
  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ManageCategoriesScreen(),
    ManageOrdersScreen(),
    ManageProductsScreen(),
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
      appBar: AppBar(
        title: const Text('Админка'),
        backgroundColor: Colors.green[700],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Категории',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Заказы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Товары',
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
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}