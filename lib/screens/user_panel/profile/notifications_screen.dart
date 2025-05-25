import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }
    return Scaffold(
      appBar: AppBar(
       title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppConstants.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }
          final notifications = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final data = notifications[index].data();
              final String orderId = data['orderId'] ?? 'Unknown';
              final String status = data['status'] ?? '';
              final bool isRead = data['isRead'] ?? false;
              final dynamic timestampRaw = data['timestamp'];
              DateTime? time;
              if (timestampRaw is Timestamp) {
                time = timestampRaw.toDate();
              } else if (timestampRaw is String) {
                time = DateTime.tryParse(timestampRaw);
              }

              // Choose icon and color based on status
              IconData iconData;
              Color iconColor = AppConstants.primaryColor;
              String displayMessage;
              switch (status) {
                case 'processing':
                  iconData = Icons.settings;
                  displayMessage = 'Your order $orderId is being processed.';
                  break;
                case 'shipped':
                  iconData = Icons.local_shipping;
                  displayMessage = 'Your order $orderId has been shipped.';
                  break;
                case 'delivered':
                  iconData = Icons.check_circle;
                  iconColor = Colors.green;
                  displayMessage = 'Your order $orderId has been delivered!';
                  break;
                case 'cancelled':
                  iconData = Icons.cancel;
                  iconColor = Colors.red;
                  displayMessage = 'Your order $orderId has been cancelled.';
                  break;
                default:
                  iconData = Icons.hourglass_empty;
                  displayMessage = 'Your order $orderId is pending.';
              }
              return Card(
                color: isRead ? Colors.white : AppConstants.surfaceColor,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: Icon(iconData, color: iconColor),
                  title: Text(displayMessage),
                  subtitle: time != null
                      ? Text(
                          '${time.day}/${time.month}/${time.year}  ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 12, color: AppConstants.primaryTextColor , fontWeight: FontWeight.bold),
                        )
                      : null,
                  trailing: isRead
                      ? null
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                  onTap: () async {
                    if (!isRead) {
                      await notifications[index].reference.update({'isRead': true});
                    }
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
