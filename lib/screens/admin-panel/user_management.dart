import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchAllUsers() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return usersSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'uid': doc.id,
        'username': data['username'] ?? 'No Name',
        'email': data['email'] ?? '',
        'isAdmin': data['isAdmin'] ?? false,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    user['username'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user['email']),
                  trailing: Tooltip(
                    message: user['isAdmin'] == true ? 'Admin User' : 'Regular User',
                    child: Icon(
                      user['isAdmin'] == true ? Icons.verified_user : Icons.person,
                      color: user['isAdmin'] == true ? Colors.blue : Colors.grey,
                    ),
                  ),

                  onTap: () {
                    Get.toNamed('/user_detail', arguments: user);
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
