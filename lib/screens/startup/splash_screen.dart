import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/screens/admin-panel/admin_dashboard.dart';
import 'package:laptops_harbour/screens/auth/login_screen.dart';
import 'package:laptops_harbour/screens/startup/onboarding.dart';
import 'package:laptops_harbour/screens/user_panel/home.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 7), () {
      _checkUserStatus(); 
    });
  }

  void _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboardingCompleted =
        prefs.getBool('isOnboardingCompleted') ?? false;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      bool isAdmin = userDoc.data()?['isAdmin'] ?? false;

      if (isAdmin) {
        Get.offAll(() => AdminDashboard());
      } else {
        Get.offAll(() => HomeScreen());
      }
    } else if (isOnboardingCompleted) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => OnboardingScreens());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/cart-animation.json',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 30),
            Text(
              AppConstants.appTitle,
              style: TextStyle(
                color: AppConstants.invertTextColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    blurRadius: 2.0,
                    color: Colors.grey[500]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
