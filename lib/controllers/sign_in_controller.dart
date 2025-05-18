import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptops_harbour/screens/user_panel/home.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';


class SignInController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? email) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$",
    );

    if (email == null || email.isEmpty) {
      return 'Email is required.';
    }

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? validatePwd(String? pwd) {
    if (pwd == null || pwd.isEmpty) {
      return 'Password is required.';
    }
    return null;
  }

  Future<void> handleSignIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final emailError = validateEmail(email);
    final passwordError = validatePwd(password);

    if (emailError != null || passwordError != null) {
      Get.snackbar(
        "Error",
        emailError ?? passwordError!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstants.primaryColor,
        colorText: AppConstants.primaryTextColor,
      );
      return;
    }

    try {
      isLoading.value = true;

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (!userCredential.user!.emailVerified) {
        Get.snackbar(
          "Error",
          "Please verify your email before logging in",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstants.primaryColor,
          colorText: AppConstants.primaryTextColor,
        );
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists && userDoc['isAdmin'] == true) {
        Get.snackbar(
          "Success",
          "Welcome Admin!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstants.primaryColor,
          colorText: AppConstants.primaryTextColor,
        );
        // Get.offAll(() => AdminDashboard());
      } else {
        Get.snackbar(
          "Success",
          "Login Successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstants.primaryColor,
          colorText: AppConstants.primaryTextColor,
        );
        Get.offAll(() => HomeScreen());
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = 'Something went wrong. Please try again.';
      if (e.code == 'user-not-found') {
        errorMsg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMsg = 'Wrong password provided.';
      }

      Get.snackbar(
        'Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstants.primaryColor,
        colorText: AppConstants.primaryTextColor,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
