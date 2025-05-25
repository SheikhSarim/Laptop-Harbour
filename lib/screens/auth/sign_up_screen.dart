import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/sign_up_controller.dart';

import 'package:laptops_harbour/utils/constants/app_constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Get the SignUpController
  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstants.appBackgroundColor,
          
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: isKeyboardVisible ? 50 : Get.height / 15),
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ), // small space between title and subtext
                    Text(
                      "Please fill in the form to continue",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstants.secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: Get.height / 20),
                    // Name field
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: signUpController.usernameController,
                          cursorColor: AppConstants.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.only(
                              top: 2.0,
                              left: 8.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Email field
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: signUpController.emailController,
                          cursorColor: AppConstants.primaryColor,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                            contentPadding: EdgeInsets.only(
                              top: 2.0,
                              left: 8.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Contact Number field
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: signUpController.contactNumberController,
                          cursorColor: AppConstants.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Contact Number",
                            prefixIcon: Icon(Icons.phone),
                            contentPadding: EdgeInsets.only(
                              top: 2.0,
                              left: 8.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Password field
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(
                          () => TextFormField(
                            controller: signUpController.passwordController,
                            obscureText:
                                !signUpController.isPasswordVisible.value,
                            cursorColor: AppConstants.primaryColor,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  signUpController.togglePasswordVisibility();
                                },
                                child:
                                    signUpController.isPasswordVisible.value
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 2.0,
                                left: 8.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height / 20),
                    // Sign Up button
                    Material(
                      child: Obx(
                        () => Container(
                          width: Get.width / 2,
                          height: Get.height / 18,
                          decoration: BoxDecoration(
                            color: AppConstants.primaryTextColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextButton(
                            onPressed:
                                signUpController.isLoading.value
                                    ? null
                                    : () async {
                                      String email =
                                          signUpController.emailController.text
                                              .trim();
                                      String password =
                                          signUpController
                                              .passwordController
                                              .text
                                              .trim();
                                      String username =
                                          signUpController
                                              .usernameController
                                              .text
                                              .trim();
                                      String contactNumber =
                                          signUpController
                                              .contactNumberController
                                              .text
                                              .trim();

                                      if (email.isEmpty ||
                                          password.isEmpty ||
                                          username.isEmpty ||
                                          contactNumber.isEmpty) {
                                        Get.snackbar(
                                          "Error",
                                          "Please enter all details",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              AppConstants.accentGrey,
                                          colorText:
                                              AppConstants.invertTextColor,
                                        );
                                      } else {
                                        await signUpController.signUp();
                                      }
                                    },
                            child:
                                signUpController.isLoading.value
                                    ? CircularProgressIndicator(
                                      color: AppConstants.invertTextColor,
                                      strokeWidth: 2,
                                    )
                                    : Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                        color: AppConstants.invertTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height / 20),

                    // Navigation to Login Screen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: AppConstants.primaryTextColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/login');
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
