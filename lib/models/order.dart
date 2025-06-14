class Order {
  String id; // This should be a UUID
  String userId;
  String status;
  DateTime createdAt;
  String? address; // Поле для адреса
  String? recipientName; // Поле для имени получателя

  Order({
    required this.userId,
    required this.status,
    required this.createdAt,
    this.id = '',
    this.address, // Добавлено поле для адреса
    this.recipientName, // Добавлено поле для имени получателя
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      address: json['address'], // Получаем адрес из JSON
      recipientName: json['recipient_name'], // Получаем имя получателя из JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'address': address, // Сохраняем адрес в JSON
      'recipient_name': recipientName, // Сохраняем имя получателя в JSON
    };
  }
}