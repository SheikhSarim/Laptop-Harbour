import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/home_controller.dart';
import 'package:laptops_harbour/screens/auth/logout.dart';
import 'package:laptops_harbour/screens/user_panel/home.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: AppConstants.surfaceColor),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppConstants.primaryColor),
              child: Obx(() {
                final HomeController controller = Get.find<HomeController>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 32, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Welcome, ${controller.username.value}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.email.value,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              }),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              label: 'Home',
              onTap: () => Get.offAll(() => HomeScreen()),
            ),
            _buildDrawerItem(
              icon: Icons.store,
              label: 'Store',
              onTap: () => Get.toNamed('/storescreenDrawer'),
            ),
            _buildDrawerItem(
              icon: Icons.favorite_border,
              label: 'Wishlist',
              onTap: () => Get.toNamed('/wishlistDrawer'),
            ),
            _buildDrawerItem(
              icon: Icons.person,
              label: 'Profile',
              onTap: () {}
              // onTap: () => Get.offAll(() => Profile()),
            ),
            _buildDrawerItem(
              icon: Icons.history,
              label: 'Order History',
              onTap: () => Get.toNamed('/order-history'),
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.logout,
              label: 'Logout',
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryIconColor),
      title: Text(
        label,
        style: TextStyle(fontSize: 16, color: AppConstants.primaryTextColor),
      ),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
}
