import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static Future<void> sendOrderStatusNotification({
    required String userId,
    required String orderId,
    required String newStatus,
  }) async {
    final notification = {
      'orderId': orderId,
      'status': newStatus,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
      'message': 'Your order #$orderId status changed to $newStatus.'
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add(notification);
  }

  static Future<int> getUnreadNotificationCount(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .get();
    return snapshot.size;
  }

  static Future<void> markAllAsRead(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.update({'read': true});
    }
  }
}
