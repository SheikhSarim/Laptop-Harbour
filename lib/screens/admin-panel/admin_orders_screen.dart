import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchUsersWithOrders() async {
    // Get all users who have at least one order
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    final List<Map<String, dynamic>> usersWithOrders = [];
    for (final userDoc in usersSnapshot.docs) {
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(userDoc.id)
          .collection('userOrders')
          .limit(1)
          .get();
      if (ordersSnapshot.docs.isNotEmpty) {
        usersWithOrders.add({
          'uid': userDoc.id,
          'name': userDoc.data()['username'] ?? 'No Name',
          'email': userDoc.data()['email'] ?? '',
        });
      }
    }
    return usersWithOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUsersWithOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users with orders found.'));
          }
          final users = snapshot.data!;
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                color: AppConstants.surfaceColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(user['email']),
                  trailing: FutureBuilder<int>(
                    future: FirebaseFirestore.instance
                        .collection('orders')
                        .doc(user['uid'])
                        .collection('userOrders')
                        .get()
                        .then((snap) => snap.size),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                            width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2));
                      }
                      final count = snapshot.data ?? 0;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Orders: $count', style: const TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      );
                    },
                  ),
                  onTap: () {
                    Get.toNamed('/admin_user_orders', arguments: user);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
