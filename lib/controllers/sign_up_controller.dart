import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:laptops_harbour/models/user_model.dart';


class SignUpController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var isKeyboardVisible = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final contactNumberController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void listenToKeyboard() {
    final keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isVisible) {
      isKeyboardVisible.value = isVisible;
    });
  }

  @override
  void onInit() {
    super.onInit();
    listenToKeyboard();
  }

  // ✅ Email validation
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

  // ✅ Password validation
  String? validatePwd(String? pwd) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    if (pwd == null || pwd.isEmpty) {
      return 'Password is required.';
    }
    if (!passwordRegex.hasMatch(pwd)) {
      return 'Password must be at least 8 characters, and include both letters and numbers.';
    }
    return null;
  }

  // ✅ Sign Up Logic
  Future<void> signUp() async {
    if (isLoading.value) return;

    // Input values
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();
    final contactNumber = contactNumberController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        contactNumber.isEmpty) {
      Get.snackbar('Error', 'All fields are required.');
      return;
    }

    final emailError = validateEmail(email);
    final passwordError = validatePwd(password);

    if (emailError != null) {
      Get.snackbar('Invalid Email', emailError);
      return;
    }

    if (passwordError != null) {
      Get.snackbar('Invalid Password', passwordError);
      return;
    }

    isLoading.value = true;

    try {
      // Create user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Save user information to Firestore
      UserModel newUser = UserModel(
        username: username,
        email: email,
        contactNumber: contactNumber,
        userId: userCredential.user!.uid,
        isAdmin: false,
        createdOn: DateTime.now(),
      );

      // Save user model to Firestore
      await newUser.saveUserToFirestore();

      // Provide feedback to the user
      Get.snackbar(
        'Success',
        'Account created successfully. Please verify your email.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Redirect to Login Screen
      Get.toNamed('/login');
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth exceptions
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The account already exists for that email.');
      } else {
        Get.snackbar('Error', 'Something went wrong. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      // Stop loading state
      isLoading.value = false;
    }
  }
}
