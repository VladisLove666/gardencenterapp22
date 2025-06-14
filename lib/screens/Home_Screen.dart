import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/Category.dart';
import 'package:gardencenterapppp/screens/product_screen.dart';
import 'package:gardencenterapppp/services/CategoryService.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Витрина'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<List<Category>>(
        future: CategoryService().getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет доступных категорий.'));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  title: Text(
                    category.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListScreen(categoryId: category.id)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}