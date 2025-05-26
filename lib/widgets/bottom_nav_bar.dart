import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/home_controller.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 10.0,
      shape: const CircularNotchedRectangle(),
      color: AppConstants.surfaceColor,
      child: Row(
        children: const [
          _BottomNavItem(index: 0, icon: Icons.home, label: 'Home'),
          _BottomNavItem(index: 1, icon: Icons.store, label: 'Store'),
          _BottomNavItem(
            index: 2,
            icon: Icons.favorite_border,
            label: 'Wishlist',
          ),
          _BottomNavItem(
            index: 3,
            icon: Icons.account_circle,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;

  const _BottomNavItem({
    required this.index,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Expanded(
      child: GestureDetector(
        onTap: () => homeController.changeTab(index),
        child: Obx(() {
          final isSelected = homeController.selectedTabIndex.value == index;
          final color =
              isSelected ? AppConstants.primaryColor : AppConstants.accentGrey;

          return SizedBox(
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(color: color, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
