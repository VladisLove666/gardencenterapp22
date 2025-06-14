import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/product.dart';
import 'package:gardencenterapppp/services/product_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? imageUrl; // URL для изображения

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    imageUrl = widget.product.imageUrl; // Предполагается, что у вас есть поле imageUrl в модели Product
  }

  Future<void> _saveProduct() async {
    // Создаем обновленный продукт
    final updatedProduct = Product(
      id: widget.product.id,
      name: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      categoryId: widget.product.categoryId,
      imageUrl: imageUrl, // Сохраняем URL изображения
    );

    // Обновляем продукт в базе данных
    await ProductService().update(updatedProduct);
    Navigator.pop(context);
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = 'products/${widget.product.id}/${pickedFile.name}'; // Уникальное имя файла

      // Загружаем изображение в Supabase Storage
      final response = await Supabase.instance.client.storage
          .from('product-images')
          .upload(fileName, file);

        final url = Supabase.instance.client.storage
            .from('product-images')
            .getPublicUrl(fileName);

        setState(() {
          imageUrl = url; // Сохраняем URL изображения
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать продукт'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Цена'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Загрузить изображение'),
            ),
            if (imageUrl != null) ...[
              SizedBox(height: 20),
              Image.network(imageUrl!, height: 150), // Отображаем загруженное изображение
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}