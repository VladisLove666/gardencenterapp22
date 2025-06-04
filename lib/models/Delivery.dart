class Delivery {
  String id;
  String orderId;
  String driverId;
  String status;
  DateTime deliveryDate;

  Delivery({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.status,
    required this.deliveryDate,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      orderId: json['order_id'],
      driverId: json['driver_id'],
      status: json['status'],
      deliveryDate: DateTime.parse(json['delivery_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'driver_id': driverId,
      'status': status,
      'delivery_date': deliveryDate.toIso8601String(),
    };
  }
}