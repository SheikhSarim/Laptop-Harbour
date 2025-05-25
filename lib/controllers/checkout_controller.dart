import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptops_harbour/controllers/cart_controller.dart';
import 'package:laptops_harbour/models/order_model.dart';
import 'package:laptops_harbour/utils/email_service.dart';

class CheckoutController extends GetxController {
  final CartController cartController = Get.put(CartController());
  var isLoading = false.obs;

  Future<String?> placeOrder(
    String address, {
    required double orderAmount,
    required double shippingFee,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return 'You must be logged in to place an order.';
    }
    if (address.trim().isEmpty) {
      return 'Please enter a delivery address.';
    }
    isLoading.value = true;
    try {
      final orderId = FirebaseFirestore.instance.collection('orders').doc().id;
      final order = OrderModel(
        orderId: orderId,
        userId: user.uid,
        items: cartController.cartItems.toList(),
        address: address.trim(),
        timestamp: DateTime.now(),
        status: 'pending',
        orderAmount: orderAmount,
        shippingFee: shippingFee,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
      );
      // Deduct product quantities
      for (final item in cartController.cartItems) {
        final productRef = FirebaseFirestore.instance
            .collection('products')
            .doc(item.productId);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final snapshot = await transaction.get(productRef);
          final currentQty = snapshot['quantity'] ?? 0;
          if (currentQty < item.quantity) {
            throw Exception('Not enough stock for ${item.title}');
          }
          transaction.update(productRef, {
            'quantity': currentQty - item.quantity,
          });
        });
      }
      // Save order to Firestore
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(user.uid)
          .collection('userOrders')
          .doc(orderId)
          .set(order.toMap());
      // Save address to user profile
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'deliveryAddress': address.trim(),
      }, SetOptions(merge: true));
      // Send order confirmation email (learning/demo only)
      await EmailService.sendOrderConfirmation(
        toEmail: user.email ?? '',
        userName: user.displayName ?? 'Customer',
        orderId: orderId,
        totalAmount: totalAmount,
      );
      // Clear cart
      cartController.clearCart();
      isLoading.value = false;
      return null;
    } catch (e) {
      isLoading.value = false;
      return e.toString();
    }
  }
}
