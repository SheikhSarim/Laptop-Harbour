import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/google_sign_in_controller.dart';
import 'package:laptops_harbour/controllers/sign_in_controller.dart';
import 'package:laptops_harbour/screens/auth/sign_up_screen.dart';
import 'package:laptops_harbour/screens/user_panel/home.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SignInController signInController = Get.put(SignInController());
  final GoogleSignInController googleSignInController = Get.put(
    GoogleSignInController(),
  );

  bool isLoading = false;

  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstants.appBackgroundColor,
            // centerTitle: true,
            // title: Text(
            //   "Sign In",
            //   style: TextStyle(
            //     color: AppConstants.primaryTextColor,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
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
                    SizedBox(height: Get.height / 10),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ), // small space between title and subtext
                    Text(
                      "Welcome back! Please enter your credentials",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstants.secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: Get.height / 20),

                    // Email TextField
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: signInController.emailController,
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

                    // Password TextField with visibility toggle
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: signInController.passwordController,
                          obscureText: !isPasswordVisible,
                          cursorColor: AppConstants.primaryColor,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              child: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
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

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Get.to(() => ForgetPasswordScreen());
                        },
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height / 20),

                    Material(
                      child: Container(
                        width: Get.width / 2,
                        height: Get.height / 18,
                        decoration: BoxDecoration(
                          color: AppConstants.secondarybackgroundColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Obx(
                          () => TextButton(
                            onPressed:
                                signInController.isLoading.value
                                    ? null
                                    : () {
                                      signInController.handleSignIn();
                                    },
                            child:
                                signInController.isLoading.value
                                    ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppConstants.appSecondaryColor,
                                      ),
                                    )
                                    : Text(
                                      "SIGN IN",
                                      style: TextStyle(
                                        color: AppConstants.appSecondaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height / 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("OR"),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                      ],
                    ),

                    SizedBox(height: Get.height / 20),

                    Material(
                      child: Obx(
                        () => Container(
                          width: Get.width / 2,
                          height: Get.height / 18,
                          decoration: BoxDecoration(
                            color: AppConstants.appSecondaryColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextButton(
                            onPressed:
                                googleSignInController.isLoading.value
                                    ? null
                                    : () async {
                                      try {
                                        await googleSignInController
                                            .signInWithGoogle();
                                      } catch (e) {
                                        Get.snackbar(
                                          "Error",
                                          "Google sign-in failed. Please try again.",
                                        );
                                      }
                                    },
                            child:
                                googleSignInController.isLoading.value
                                    ? CircularProgressIndicator(
                                      color: AppConstants.primaryTextColor,
                                      strokeWidth: 2,
                                    )
                                    : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/final-google-logo.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Continue with Google",
                                          style: TextStyle(
                                            color:
                                                AppConstants.primaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height / 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: AppConstants.primaryTextColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.offAll(() => SignUpScreen()),
                          child: Text(
                            "Sign Up",
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
