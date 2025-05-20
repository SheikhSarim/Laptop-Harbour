import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/screens/auth/login_screen.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  int _currentIndex = 0;

  List<Map<String, String>> get splashData {
    final appName = AppConstants.appTitle;
    // final appName = Text("Laptops Haorbour");
    return [
      {
        "text":
            "Welcome to $appName – Browse a wide range of laptops by brand, price, and specs.",
        "image": "assets/images/Usability testing-pana.png",
      },
      {
        "text":
            "Your feedback matters — rate products and write reviews after purchase.",
        "image": "assets/images/Feedback-cuate.png",
      },
      {
        "text":
            "Enjoy a seamless and secure checkout process — shop with confidence, only at $appName.",
        "image": "assets/images/Credit Card Payment.png",
      },
    ];
  }

  // Save onboarding completion status
  void completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isOnboardingCompleted', true);
  }

  @override
  void initState() {
    super.initState();
    // _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider.builder(
            itemCount: splashData.length,
            itemBuilder: (context, index, realIndex) {
              final item = splashData[index];
              return Container(
               
                width: screenWidth,
                color: AppConstants.surfaceColor,
                // color: AppConstants.appBackgroundColor,
                child: Center(
                  child: Image.asset(
                    item["image"]!,
                    height: screenHeight * 0.8, 
                    fit: BoxFit.contain, 
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: screenHeight,
              initialPage: _currentIndex,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              autoPlay: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),

          /// Dots Indicator
          Positioned(
            bottom: 20,
            left: screenWidth / 2 - 40,
            child: Row(
              children: List.generate(splashData.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentIndex == index ? 12 : 8,
                  height: _currentIndex == index ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentIndex == index
                            ? AppConstants.primaryColor
                            : AppConstants.accentGrey,
                  ),
                );
              }),
            ),
          ),

          /// Bottom Text and Buttons
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.appSecondaryColor,
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.1),
                //     blurRadius: 10,
                //     spreadRadius: 5,
                //   ),
                // ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    splashData[_currentIndex]["text"]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),

                  /// Skip Button
                  if (_currentIndex < splashData.length - 1)
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _currentIndex = splashData.length - 1;
                          });
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.appButtonColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  /// Get Started Button
                  if (_currentIndex == splashData.length - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.appButtonColor,
                      ),
                      onPressed: () {
                        // Temporarily navigate to LoginScreen directly
                        Get.offAll(() => LoginScreen());
                      },
                      child: Text(
                        "Let’s Get Started →",
                        style: TextStyle(
                          color: AppConstants.appSecondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
