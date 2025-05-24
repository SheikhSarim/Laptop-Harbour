import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptops_harbour/models/order_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:laptops_harbour/utils/notification_service.dart';
import 'package:get/get.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  Future<List<OrderModel>> _fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    // print('Current user UID: ${user?.uid}');
    if (user == null) return [];
    final snapshot =
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(user.uid)
            .collection('userOrders')
            .orderBy('timestamp', descending: true)
            .get();
    // print('Fetched ${snapshot.docs.length} orders for user ${user.uid}');
    try {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // print('Order parsing error: $e\n$st');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: AppConstants.primaryColor,
        actions: [
          if (user != null)
            FutureBuilder<int>(
              future: NotificationService.getUnreadNotificationCount(user.uid),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                if (count == 0) return const SizedBox.shrink();
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: AppConstants.appSecondaryColor,
                      ),
                      onPressed: () async {
                        await NotificationService.markAllAsRead(user.uid);
                        // Instead of navigating away and back, use setState or a callback to refresh
                        // Since this is a StatelessWidget, use Get.forceAppUpdate() to force a rebuild
                        Get.forceAppUpdate();
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppConstants.appButtonColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No orders found.'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final formattedTotal = NumberFormat.simpleCurrency().format(
                order.totalAmount,
              );
              return Card(
                color: AppConstants.surfaceColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.orderId.substring(0, 8)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  order.status == 'pending'
                                      ? AppConstants.accentGrey
                                      : AppConstants.priceGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order.status[0].toUpperCase() +
                                  order.status.substring(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${DateFormat('MMM d, yyyy').format(order.timestamp)}',
                        style: const TextStyle(
                          color: AppConstants.secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Address: ${order.address}',
                        style: const TextStyle(
                          color: AppConstants.secondaryTextColor,
                        ),
                      ),
                      const Divider(height: 24),
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                'x${item.quantity}',
                                style: const TextStyle(
                                  color: AppConstants.accentDarkGrey,
                                ),
                              ),
                              Text(
                                NumberFormat.simpleCurrency().format(
                                  item.price * item.quantity,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Order:', style: TextStyle(fontSize: 15)),
                          Text(
                            NumberFormat.simpleCurrency().format(
                              order.orderAmount,
                            ),
                          ),
                        ],
                      ),
                      if (order.orderAmount !=
                          order.totalAmount - order.shippingFee)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Discount:',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppConstants.priceGreen,
                              ),
                            ),
                            Text(
                              '-' +
                                  NumberFormat.simpleCurrency().format(
                                    order.orderAmount -
                                        (order.totalAmount - order.shippingFee),
                                  ),
                              style: const TextStyle(
                                color: AppConstants.priceGreen,
                              ),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Shipping:',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            NumberFormat.simpleCurrency().format(
                              order.shippingFee,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            NumberFormat.simpleCurrency().format(
                              order.totalAmount,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.payment,
                                size: 18,
                                color: AppConstants.accentDarkGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                order.paymentMethod,
                                style: const TextStyle(
                                  color: AppConstants.accentDarkGrey,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            formattedTotal,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
