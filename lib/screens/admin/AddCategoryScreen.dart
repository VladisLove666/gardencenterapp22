import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/Category.dart';
import 'package:gardencenterapppp/services/CategoryService.dart';
import 'package:uuid/uuid.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _addCategory() async {
    final name = _nameController.text;
    if (name.isNotEmpty) {
      final categoryId = Uuid().v4(); // Генерируем новый UUID
      final newCategory = Category(id: categoryId, name: name); // Создаем новую категорию с UUID
      await CategoryService().create(newCategory); // Сохраняем категорию в базе данных
      Navigator.pop(context); // Возвращаемся на предыдущий экран
    } else {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Введите название категории.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить категорию'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Название категории'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCategory,
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}