import 'package:flutter/material.dart';
import 'package:laptops_harbour/screens/admin-panel/admin_orders_screen.dart';
import 'package:laptops_harbour/screens/admin-panel/brand_management.dart';
import 'package:laptops_harbour/screens/admin-panel/product_management.dart';
import 'package:laptops_harbour/screens/admin-panel/admin_home.dart';
import 'package:laptops_harbour/screens/admin-panel/user_management.dart';
import 'package:laptops_harbour/screens/auth/logout.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Number of tabs
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
              Tab(
                icon: Icon(Icons.dashboard),
                text: 'Home',
              ), // For admin dashboard or overview

              Tab(
                icon: Icon(Icons.laptop_mac),
                text: 'Products',
              ), // Specific to laptops/products

              Tab(
                icon: Icon(Icons.person),
                text: 'Users',
              ), // Represents individual user

              Tab(
                icon: Icon(Icons.business),
                text: 'Brands',
              ), // Represents business or brands

              Tab(
                icon: Icon(Icons.shopping_bag),
                text: 'Orders',
              ), // Represents eCommerce orders
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AdminHome(),
            ProductManagementScreen(),
            UserManagementScreen(),
            BrandManagementScreen(),
            AdminOrdersScreen(),
          ],
        ),
      ),
    );
  }
}
