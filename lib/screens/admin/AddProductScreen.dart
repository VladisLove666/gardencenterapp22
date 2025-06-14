import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/product.dart';
import 'package:gardencenterapppp/services/product_service.dart';
import 'package:gardencenterapppp/services/CategoryService.dart'; // Импортируем сервис категорий
import 'package:gardencenterapppp/models/Category.dart';
import 'package:uuid/uuid.dart'; // Импортируем модель категории

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedCategoryId; // Переменная для хранения выбранной категории
  List<Category> _categories = []; // Список категорий

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Загружаем категории при инициализации
  }

  Future<void> _fetchCategories() async {
    _categories = await CategoryService().getAll();
    setState(() {}); // Обновляем состояние после загрузки категорий
  }

  void _addProduct() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final price = double.tryParse(_priceController.text);

    if (name.isNotEmpty && description.isNotEmpty && price != null && _selectedCategoryId != null) {
      final productId = Uuid().v4(); // Генерируем новый UUID
      final newProduct = Product(
        id: productId, // Устанавливаем сгенерированный ID
        name: name,
        description: description,
        price: price,
        categoryId: _selectedCategoryId!, // Устанавливаем выбранную категорию
      );

      await ProductService().create(newProduct); // Сохраняем товар в базе данных
      Navigator.pop(context); // Возвращаемся на предыдущий экран
    } else {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Пожалуйста, заполните все поля.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить товар'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Название товара'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание товара'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Цена'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              hint: Text('Выберите категорию'),
              value: _selectedCategoryId,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategoryId = newValue;
                });
              },
              items: _categories.map<DropdownMenuItem<String>>((Category category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}