import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/Category.dart';
import 'package:gardencenterapppp/screens/admin/EditCategoryScreen.dart';
import 'package:gardencenterapppp/screens/admin/AddCategoryScreen.dart'; // Импортируем экран добавления категории
import 'package:gardencenterapppp/services/CategoryService.dart';

class ManageCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление категориями'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryScreen()), // Открываем экран добавления категории
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: CategoryService().getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет доступных категорий.'));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  title: Text(category.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditCategoryScreen(category: category)),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          // Подтверждение удаления
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Удалить категорию?'),
                                content: Text('Вы уверены, что хотите удалить категорию "${category.name}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('Отмена'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text('Удалить'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmDelete == true) {
                            await CategoryService().delete(category.id); // Удаляем категорию
                            // Обновляем экран
                            (context as Element).reassemble();
                          }
                        },
                      ),
                    ],
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