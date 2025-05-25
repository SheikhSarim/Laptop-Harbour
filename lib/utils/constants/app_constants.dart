import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConstants {
  static String appMainName = '';
  static String appVersion = '';
  static String appTitle = 'Laptop Harbor';
  static String appAuthor = 'Powered by: Shiekh Sarim';

  // 🎨 Color Palette
  /// Primary & Secondary Colors
  static const Color primaryColor = Color(0xFFFF543D);
  static const Color appSecondaryColor = Color(0xFFE5E7EB); 

  /// Text Colors
  static const Color primaryTextColor = Color(0xFF1A1A1A); 
  static const Color secondaryTextColor = Color(0xFF6E6E6E); 
  static const Color invertTextColor = Color(0xFFE0E0E0);

  /// Background & Surface
  static const Color backgroundColor = Color(0xFFF9F9F9); 
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static final Color appBackgroundColor = backgroundColor;

  /// Accent Colors
  static const Color accentDarkGrey = Color(0xFF555555);
  static const Color accentGrey = Color(0xFF9B9B9B);

  /// Pricing Indicators
  static const Color priceGreen = Color(0xFF4CAF50);
  static const Color priceBlue = Color(0xFF42A5F5);

  /// Icon Colors
  static const Color primaryIconColor = Color(0xFF1A1A1A);

  /// Button & Card Colors
  static const Color appButtonColor = Color(0xFF1A1A1A);
  static const Color cardColor = surfaceColor;

  /// Status Bar
  static const Color appStatusBarColor = primaryColor;

  /// Profile Screen
  static const Color profilescreenBackground = Color(0xFF2C2C2C); // Charcoal Black

  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    appMainName = info.appName;
    appVersion = info.version;
  }
}
