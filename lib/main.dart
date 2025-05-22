import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/cart_controller.dart';
import 'package:laptops_harbour/controllers/product_controller.dart';
import 'package:laptops_harbour/firebase_options.dart';
import 'package:laptops_harbour/screens/admin-panel/admin_dashboard.dart';
import 'package:laptops_harbour/screens/auth/login_screen.dart';
import 'package:laptops_harbour/screens/auth/sign_up_screen.dart';
import 'package:laptops_harbour/screens/startup/onboarding.dart';
import 'package:laptops_harbour/screens/startup/splash_screen.dart';
import 'package:laptops_harbour/screens/user_panel/home.dart';
import 'package:laptops_harbour/screens/user_panel/product/product_detals.dart';
import 'package:laptops_harbour/screens/user_panel/store/store.dart';
import 'package:laptops_harbour/screens/user_panel/cart/cart_screen.dart';
import 'package:laptops_harbour/screens/user_panel/store/store_screen.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(CartController()); // Ensure CartController is available globally
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
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),

        GetPage(name: '/onboarding', page: () => OnboardingScreens()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/admin', page: () => AdminDashboard()),
        GetPage(name: '/store', page: () => Store()),
        GetPage(name: '/storescreen', page: () => StoreScreen()),
        GetPage(name: '/cart', page: () {
          final ProductController productController = Get.find<ProductController>();
          return CartScreen(products: productController.products);
        }),

        // For ProductDetails: using parameters
        GetPage(
          name: '/productDetails/:productId',
          page:
              () =>
                  ProductDetails(productId: Get.parameters['productId'] ?? ''),
        ),

        // Optionally, add a placeholder for checkout
        GetPage(
          name: '/checkout',
          page: () => Scaffold(
            appBar: AppBar(title: Text('Checkout')),
            body: Center(child: Text('Checkout Screen')),
          ),
        ),
      ],
    );
  }
}
