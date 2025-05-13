import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter E-Commerce App',
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.lightTheme, // You can define light/dark theme in app_theme.dart
      // initialRoute: AppRoutes.initial, // e.g., AppRoutes.splash or AppRoutes.login
      // routes: AppRoutes.routes,
      home: Scaffold(body: Center(child: Text('Testing'))),
    );
  }
}
