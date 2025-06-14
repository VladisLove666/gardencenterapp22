class CartItem {
  String id; // UUID
  String cartId; // UUID
  String productId; // UUID
  int quantity;

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}