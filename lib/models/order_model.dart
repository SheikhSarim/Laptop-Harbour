import 'package:laptops_harbour/models/cart_item.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartItem> items;
  final String address;
  final DateTime timestamp;
  final String status;
  final double orderAmount;
  final double shippingFee;
  final double totalAmount;
  final String paymentMethod;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.address,
    required this.timestamp,
    this.status = 'pending',
    required this.orderAmount,
    required this.shippingFee,
    required this.totalAmount,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() => {
        'orderId': orderId,
        'userId': userId,
        'items': items.map((e) => e.toJson()).toList(),
        'address': address,
        'timestamp': timestamp.toIso8601String(),
        'status': status,
        'orderAmount': orderAmount,
        'shippingFee': shippingFee,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
      };

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        orderId: map['orderId'],
        userId: map['userId'],
        items: (map['items'] as List)
            .map((e) => CartItem.fromJson(e))
            .toList(),
        address: map['address'],
        timestamp: DateTime.parse(map['timestamp']),
        status: map['status'] ?? 'pending',
        orderAmount: (map['orderAmount'] is num)
            ? (map['orderAmount'] as num).toDouble()
            : 0.0,
        shippingFee: (map['shippingFee'] is num)
            ? (map['shippingFee'] as num).toDouble()
            : 0.0,
        totalAmount: (map['totalAmount'] is num)
            ? (map['totalAmount'] as num).toDouble()
            : 0.0,
        paymentMethod: map['paymentMethod'] ?? '',
      );

  // For Firestore compatibility
  Map<String, dynamic> toJson() => toMap();
  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel.fromMap(json);

  // Optional: for easier updates
  OrderModel copyWith({
    String? orderId,
    String? userId,
    List<CartItem>? items,
    String? address,
    DateTime? timestamp,
    String? status,
    double? orderAmount,
    double? shippingFee,
    double? totalAmount,
    String? paymentMethod,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      address: address ?? this.address,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      orderAmount: orderAmount ?? this.orderAmount,
      shippingFee: shippingFee ?? this.shippingFee,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
