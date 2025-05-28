class Order {
  final String id;
  final String userId;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}