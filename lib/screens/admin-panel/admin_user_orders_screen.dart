import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:laptops_harbour/utils/notification_service.dart';

class AdminUserOrdersScreen extends StatefulWidget {
  const AdminUserOrdersScreen({super.key});

  @override
  State<AdminUserOrdersScreen> createState() => _AdminUserOrdersScreenState();
}

class _AdminUserOrdersScreenState extends State<AdminUserOrdersScreen> {
  late final String userId;
  late final String userName;
  late final String userEmail;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    userId = args['uid'];
    userName = args['name'];
    userEmail = args['email'];
  }

  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(userId)
            .collection('userOrders')
            .orderBy('timestamp', descending: true)
            .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['orderId'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(userId)
        .collection('userOrders')
        .doc(orderId)
        .update({'status': newStatus});
    // Send notification to user
    await NotificationService.sendOrderStatusNotification(
      userId: userId,
      orderId: orderId,
      newStatus: newStatus,
    );
    Get.snackbar(
      'Order Status Updated',
      'Order status changed to "$newStatus".',
      backgroundColor: AppConstants.priceGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    setState(() {}); // Refresh orders
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders of $userName'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found for this user.'));
          }
          final orders = snapshot.data!;
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderId = order['orderId'];
              final status = order['status'] ?? 'pending';
              final total = order['totalAmount'] ?? 0.0;
              final timestamp =
                  order['timestamp'] != null
                      ? DateTime.parse(order['timestamp'])
                      : null;
              return Card(
                color: AppConstants.surfaceColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Order #$orderId',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DropdownButton<String>(
                            value: status,
                            items: const [
                              DropdownMenuItem(
                                value: 'pending',
                                child: Text('Pending'),
                              ),
                              DropdownMenuItem(
                                value: 'processing',
                                child: Text('Processing'),
                              ),
                              DropdownMenuItem(
                                value: 'shipped',
                                child: Text('Shipped'),
                              ),
                              DropdownMenuItem(
                                value: 'delivered',
                                child: Text('Delivered'),
                              ),
                              DropdownMenuItem(
                                value: 'cancelled',
                                child: Text('Cancelled'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null && value != status) {
                                _updateOrderStatus(orderId, value);
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      if (timestamp != null)
                        Text(
                          'Date: ${DateFormat('MMM d, yyyy').format(timestamp)}',
                          style: const TextStyle(
                            color: AppConstants.secondaryTextColor,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'Total:\$${NumberFormat("#,##0.00", "en_US").format(total)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: $status',
                        style: const TextStyle(
                          color: AppConstants.primaryColor,
                        ),
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
