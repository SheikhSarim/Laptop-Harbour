import 'package:flutter/material.dart';
import 'package:laptops_harbour/screens/admin-panel/brand_management.dart';
import 'package:laptops_harbour/screens/admin-panel/product_management.dart';
import 'package:laptops_harbour/screens/auth/logout.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: AppConstants.primaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                logout();
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.place), text: 'Products'),
              Tab(icon: Icon(Icons.people), text: 'Users'),
              Tab(icon: Icon(Icons.store), text: 'Brands'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProductManagementScreen(),
            Center(child: Text('Users tab UI goes here')),
            BrandManagementScreen(),
          ],
        ),
      ),
    );
  }
}
