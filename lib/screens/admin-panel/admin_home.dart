import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:get/get.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int productsCount = 0;
  int usersCount = 0;
  int brandsCount = 0;
  int ordersCount = 0;
  bool isLoading = true;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> fetchCounts() async {
    final products = await FirebaseFirestore.instance.collection('products').get();
    final users = await FirebaseFirestore.instance.collection('users').get();
    final brands = await FirebaseFirestore.instance.collection('brands').get();
    final orders = await FirebaseFirestore.instance.collectionGroup('userOrders').get();
    if (!_disposed && mounted) {
      setState(() {
        productsCount = products.size;
        usersCount = users.size;
        brandsCount = brands.size;
        ordersCount = orders.size;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard('Products', productsCount, Icons.laptop),
                    _buildStatCard('Users', usersCount, Icons.person),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard('Brands', brandsCount, Icons.branding_watermark),
                    _buildStatCard('Orders', ordersCount, Icons.shopping_cart),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: AppConstants.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Get.toNamed('/admin-banners');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Banners', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(height: 12),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                //   decoration: BoxDecoration(
                //     color: AppConstants.surfaceColor,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: const [
                //       Text('Coupons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                //       Icon(Icons.chevron_right),
                //     ],
                //   ),
                // ),
              ],
            ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon) {
    return Expanded(
      child: Card(
        color: AppConstants.surfaceColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: AppConstants.primaryColor),
              const SizedBox(height: 8),
              Text('$count', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 15, color: AppConstants.secondaryTextColor)),
            ],
          ),
        ),
      ),
    );
  }
}
