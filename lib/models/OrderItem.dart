class OrderItem {
  String id; // UUID
  String orderId; // UUID
  String productId; // UUID
  int quantity;
  String productName; // Имя товара
  double price; // Цена товара

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.price, // Добавлено поле для цены
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      productName: json['products']['name'], // Получаем имя товара
      price: json['products']['price'], // Получаем цену товара
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}