
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/screens/auth/login_screen.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: unused_field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> forgetPasswordMethod(String userEmail) async {
    try {
      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
        "Request sent Successfully",
        "Password Reset Link sent to $userEmail",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstants.appSecondaryColor,
        colorText: AppConstants.appSecondaryColor,
      );
      Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstants.appSecondaryColor,
        colorText: AppConstants.appSecondaryColor,
      );
    }
  }
}
