import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/screens/startup/onboarding.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate delay and move to onboarding/login screen
    Future.delayed(Duration(seconds: 5), () {
      // TODO: Replace with actual logic later
      Get.offAll(() => OnboardingScreens());
      // For preview/testing you can also try:
      // Get.offAll(() => LoginScreen());
      // Get.offAll(() => HomeScreen());
      // Get.offAll(() => AdminDashboard());
    });
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
