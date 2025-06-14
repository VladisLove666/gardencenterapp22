import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/product.dart';
import 'package:gardencenterapppp/screens/admin/EditProductScreen.dart';
import 'package:gardencenterapppp/screens/admin/AddProductScreen.dart'; // Импортируем экран добавления товара
import 'package:gardencenterapppp/services/product_service.dart';

class ManageProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление товарами'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()), // Открываем экран добавления товара
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: ProductService().getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет доступных товаров.'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  title: Text(product.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${product.price} ₽', style: TextStyle(color: Colors.green[700])),
                      Text('Количество на складе: ${product.stock}', style: TextStyle(color: Colors.grey[600])), // Отображаем количество товара
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProductScreen(product: product)),
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
                                title: Text('Удалить товар?'),
                                content: Text('Вы уверены, что хотите удалить товар "${product.name}"?'),
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
                            await ProductService().delete(product.id); // Удаляем товар
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