// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// class AppConstants {
//   static String appMainName = '';
//   static String appVersion = '';
//   static String appTitle = 'City Guide';
//   static String appAuthor = 'Powered by: Sheikh Sarim';

//   static const appMainColor = Color(0xFFFF543D);
//   static const appSecondaryColor = Color(0xFFFAF4F4);
//   static const appMainTextColor = Color(0xFF222222);
//   static const appSecondaryTextColor = Colors.white;
//   static const appStatusBarColor = Color(0xFF9F9F9F);
//   static const appAccentColor = Color(0xFF9B9B9B);
//   static const appContainerColor = Color(0xFFFFFFFF);
//   static final appBackgroundColor = Colors.grey[100]; Color(0xFFF5F5F5)

//   static Future<void> init() async {
//     final info = await PackageInfo.fromPlatform();
//     appMainName = info.appName;
//     appVersion = info.version;
//   }
// }

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConstants {
  static String appMainName = '';
  static String appVersion = '';
  static String appTitle = 'Laptop Harbor';
  static String appAuthor = 'Powered by: Your Name';

  // 🎨 Color Palette
  // static const primaryColor = Color(0xFF2C2C2C); // Charcoal Black
  static const primaryColor = Color(0xFFFF543D);
  static const appSecondaryColor = Color(0xFFE5E7EB); // Slate Gray

  static const accentAmber = Color(0xFFFFC107); // Amber Yellow
  static const accentBlue = Color(0xFF36A3F2); // Sky Blue
  static const accentDarkGrey = Color(0xFF555555);
  static const accentGrey = Color(0xFF9B9B9B);

  static const backgroundColor = Color(0xFFF9FAFB); // Snow Gray
  static const surfaceColor = Color(0xFFFFFFFF); // Soft White

  static const primaryTextColor = Color(0xFF1A1A1A); // Almost Black
  static const secondaryTextColor = Color(0xFF6E6E6E); // Medium Grey
  static const invertTextColor = Color(0xFFE0E0E0); // Medium Grey

  static const appButtonColor = Color(0xFF1A1A1A);

   static const primaryIconColor = Color(0xFF1A1A1A);

  static const appStatusBarColor = primaryColor;

  // You can use this for cards, modals, inputs, etc.
  static const cardColor = surfaceColor;

  // For shared use in themes if needed
  static final appBackgroundColor = backgroundColor;
  // static const secondarybackgroundColor = Color(0xFF2C2C2C);

  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    appMainName = info.appName;
    appVersion = info.version;
  }
}
