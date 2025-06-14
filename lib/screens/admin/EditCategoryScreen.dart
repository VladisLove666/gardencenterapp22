import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/Category.dart';
import 'package:gardencenterapppp/services/CategoryService.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category category;

  EditCategoryScreen({required this.category});

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.category.name;
  }

  Future<void> _saveCategory() async {
    final updatedCategory = Category(
      id: widget.category.id,
      name: nameController.text,
    );

    await CategoryService().update(updatedCategory);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать категорию'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Название категории'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCategory,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}