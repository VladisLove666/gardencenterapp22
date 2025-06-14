class Product {
  String id; // UUID
  String name;
  String description;
  double price;
  String categoryId;
  String? imageUrl; // Поле для URL изображения
  int stock; // Поле для количества товара на складе

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.imageUrl,
    this.stock = 0, // Инициализируем количество товара
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      categoryId: json['category_id'],
      imageUrl: json['image_url'],
      stock: json['stock'] ?? 0, // Получаем количество товара из JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'image_url': imageUrl,
      'stock': stock, // Сохраняем количество товара в JSON
    };
  }
}