import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/firebase_options.dart';
import 'package:laptops_harbour/screens/startup/splash_screen.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LaptopHarbourApp());
}

class LaptopHarbourApp extends StatelessWidget {
  const LaptopHarbourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter E-Commerce App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: AppConstants.appBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: AppConstants.appSecondaryColor,
        ),

        bottomAppBarTheme: BottomAppBarTheme(
          color: AppConstants.appBackgroundColor,
        ),
      ),
      home: SplashScreen(),
      initialRoute: '/',
      getPages: [GetPage(name: '/', page: () => SplashScreen())],
    );
  }
}
