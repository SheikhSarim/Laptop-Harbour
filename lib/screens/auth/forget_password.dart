import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/forget_password_controller.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final ForgetPasswordController forgetPasswordController = Get.put(
    ForgetPasswordController(),
  );
  TextEditingController userEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstants.appBackgroundColor,
            iconTheme: IconThemeData(color: AppConstants.primaryIconColor),
            automaticallyImplyLeading: true,
            // centerTitle: true,
            // title: Text(
            //   "Forget Password",
            //   style: TextStyle(color: AppConstants.primaryTextColor),
            // ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height / 10),
                Text(
                  "Forget Password",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryTextColor,
                  ),
                ),
                SizedBox(height: Get.height / 25),
                Text(
                  "Enter the email associated with your account and we’ll send an email with code to reset your password",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppConstants.secondaryTextColor,
                  ),
                ),
                SizedBox(height: Get.height / 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: userEmail,
                      cursorColor: AppConstants.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
                      color: AppConstants.appButtonColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextButton(
                      child: Text(
                        "Forget Password",
                        style: TextStyle(color: AppConstants.invertTextColor),
                      ),
                      onPressed: () async {
                        String email = userEmail.text.trim();
                        if (email.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please Enter all the details",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstants.appSecondaryColor,
                            colorText: AppConstants.primaryTextColor,
                          );
                        } else {
                          String email = userEmail.text.trim();
                          forgetPasswordController.forgetPasswordMethod(email);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
