import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          color: AppConstants.surfaceColor,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      user['isAdmin'] == true ? Icons.verified_user : Icons.person,
                      color: user['isAdmin'] == true ? Colors.blue : Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      user['username'] ?? 'No Name',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Email: ${user['email']}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('User ID: ${user['uid']}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Admin: ${user['isAdmin'] == true ? 'Yes' : 'No'}', style: const TextStyle(fontSize: 16)),
                // Add more fields as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
