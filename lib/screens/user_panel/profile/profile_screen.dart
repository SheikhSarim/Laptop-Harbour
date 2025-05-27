import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? 'No Email';

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future:
          user != null
              ? FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get()
              : Future.value(
                FirebaseFirestore.instance
                    .collection('users')
                    .doc('dummy')
                    .get(),
              ),
      builder: (context, snapshot) {
        String name = 'No Name';
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.data() != null) {
          name = snapshot.data!.data()!['username'] ?? 'No Name';
        }
        return Scaffold(
          body: Stack(
            children: [
              // Decorative background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.profilescreenBackground,
                      AppConstants.primaryColor,
                      AppConstants.accentGrey,
                    ],
                  ),
                ),
              ),
              // Decorative circles/ellipses
              Positioned(
                top: -60,
                left: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.10),
                  ),
                ),
              ),
              Positioned(
                top: 120,
                right: -60,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: 40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
              // Main content
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile avatar with subtle shadow
                      const SizedBox(height: 10),

                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.primaryColor.withOpacity(
                                0.18,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: AssetImage(
                            'assets/images/profileDefaultImg.jpg',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _ProfileOption(
                        icon: Icons.edit,
                        label: 'Edit Profile Info',
                        onTap: () {
                          Get.toNamed('/edit-profile');
                        },
                      ),
                      _ProfileOption(
                        icon: Icons.lock_reset,
                        label: 'Reset Password',
                        onTap: () {
                          Get.toNamed('/reset-password');
                        },
                      ),
                      _ProfileOption(
                        icon: Icons.history,
                        label: 'Order History',
                        onTap: () {
                          Get.toNamed('/order-history');
                        },
                      ),
                      _ProfileOption(
                        icon: Icons.description,
                        label: 'Terms & Conditions',
                        onTap: () {
                          Get.toNamed('/terms-and-conditions');
                        },
                      ),
                      _ProfileOption(
                        icon: Icons.privacy_tip,
                        label: 'Privacy Policy',
                        onTap: () {
                          Get.toNamed('/privacy-policy');
                        },
                      ),
                      _ProfileOption(
                        icon: Icons.notifications,
                        label: 'Notifications',
                        onTap: () {
                          Get.toNamed('/notifications');
                        },
                      ),
                       _ProfileOption(
                        icon: Icons.notifications,
                        label: 'Feedback',
                        onTap: () {
                          Get.toNamed('/feedback');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppConstants.primaryColor),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
