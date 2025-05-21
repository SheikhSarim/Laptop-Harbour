class CartItem {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'],
        title: json['title'],
        imageUrl: json['imageUrl'],
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'],
      );
}
