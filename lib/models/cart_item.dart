class CartItem {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  int quantity;
  final int availableQuantity;  
  CartItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    required this.availableQuantity,  
  });

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
        'availableQuantity': availableQuantity,  
      };

  // Convert JSON to CartItem
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'],
        title: json['title'],
        imageUrl: json['imageUrl'],
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'],
        availableQuantity: json['availableQuantity'], 
      );
}
