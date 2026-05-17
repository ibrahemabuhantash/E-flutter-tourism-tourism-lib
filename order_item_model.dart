class OrderItemModel {
  final String title;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.title,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      title: json['title'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
