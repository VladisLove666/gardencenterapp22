import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/order.dart';
import 'package:gardencenterapppp/services/order_service.dart';

class OrderNotifier extends ValueNotifier<List<Order>> {
  OrderNotifier() : super([]);

  void updateOrders(List<Order> orders) {
    value = orders; // Обновляем значение
  }
}