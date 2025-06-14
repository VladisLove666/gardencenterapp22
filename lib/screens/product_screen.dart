import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/product.dart';
import 'package:gardencenterapppp/services/product_service.dart';
import 'package:gardencenterapppp/services/cart_service.dart';
import 'package:gardencenterapppp/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:gardencenterapppp/providers/auth_provider.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryId;

  ProductListScreen({required this.categoryId});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final products = await ProductService().getAllByCategory(widget.categoryId);
    setState(() {
      _products = products;
      _filteredProducts = products; // Изначально показываем все продукты
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Товары'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterProducts,
              decoration: InputDecoration(
                labelText: 'Поиск по названию',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(child: Text('Нет доступных товаров.'))
                : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      product.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${product.price} ₽',
                      style: TextStyle(fontSize: 16, color: Colors.green[700]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
                      );
                    },
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await CartService().addToCart(userId, product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.name} добавлен в корзину')),
                        );
                      },
                      child: Text('Добавить в корзину'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.green[700],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}