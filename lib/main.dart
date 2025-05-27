import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/cart_controller.dart';
import 'package:laptops_harbour/controllers/product_controller.dart';
import 'package:laptops_harbour/firebase_options.dart';
import 'package:laptops_harbour/screens/admin-panel/admin_dashboard.dart';
import 'package:laptops_harbour/screens/admin-panel/admin_user_orders_screen.dart';
import 'package:laptops_harbour/screens/admin-panel/user_detail_screen.dart';
import 'package:laptops_harbour/screens/admin-panel/user_feedback.dart';
import 'package:laptops_harbour/screens/auth/login_screen.dart';
import 'package:laptops_harbour/screens/auth/sign_up_screen.dart';
import 'package:laptops_harbour/screens/startup/onboarding.dart';
import 'package:laptops_harbour/screens/startup/splash_screen.dart';
import 'package:laptops_harbour/screens/user_panel/brands/brand_screen.dart';
import 'package:laptops_harbour/screens/user_panel/home.dart';
import 'package:laptops_harbour/screens/user_panel/product/product_detals.dart';
import 'package:laptops_harbour/screens/user_panel/profile/feedback_screen.dart';
import 'package:laptops_harbour/screens/user_panel/profile/reset_password.dart';
import 'package:laptops_harbour/screens/user_panel/search_screen.dart';
import 'package:laptops_harbour/screens/user_panel/store/store.dart';
import 'package:laptops_harbour/screens/user_panel/cart/cart_screen.dart';
import 'package:laptops_harbour/screens/user_panel/store/store_screen.dart';
import 'package:laptops_harbour/screens/user_panel/wishlist/wishlist.dart';
import 'package:laptops_harbour/screens/user_panel/wishlist/wishlist_screen.dart';
import 'package:laptops_harbour/screens/user_panel/order/order_history_screen.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'screens/user_panel/cart/checkout_screen.dart';
import 'package:laptops_harbour/screens/admin-panel/banners.dart';
import 'screens/user_panel/profile/edit_profile_screen.dart';
import 'screens/user_panel/profile/notifications_screen.dart';
import 'screens/user_panel/profile/terms_and_conditions_screen.dart';
import 'screens/user_panel/profile/privacy_policy_screen.dart';

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
        GetPage(name: '/searchscreen', page: () => SearchScreen()),
        GetPage(name: '/wishlistscreen', page: () => WishlistScreen()),

        //cloned
        GetPage(name: '/storescreenDrawer', page: () => StoreScreen()),
        GetPage(name: '/wishlistDrawer', page: () => Wishlist()),

        GetPage(
          name: '/cart',
          page: () {
            final ProductController productController =
                Get.find<ProductController>();
            return CartScreen(products: productController.products);
          },
        ),

        // For ProductDetails: using parameters
        GetPage(
          name: '/productDetails/:productId',
          page:
              () =>
                  ProductDetails(productId: Get.parameters['productId'] ?? ''),
        ),
        GetPage(
          name: '/brand-details',
          page: () => BrandDetailsScreen(brand: Get.arguments),
        ),

        GetPage(name: '/checkout', page: () => CheckoutScreen()),
        GetPage(name: '/order-history', page: () => const OrderHistoryScreen()),

        GetPage(name: '/reset-password', page: () => ResetPasswordScreen()),
        GetPage(name: '/feedback', page: () => FeedbackScreen()),
        GetPage(name: '/edit-profile', page: () => const EditProfileScreen()),
        GetPage(
          name: '/notifications',
          page: () => const NotificationsScreen(),
        ),
        GetPage(
          name: '/terms-and-conditions',
          page: () => const TermsAndConditionsScreen(),
        ),
        GetPage(
          name: '/privacy-policy',
          page: () => const PrivacyPolicyScreen(),
        ),

        //admin-routes
        GetPage(
          name: '/admin_user_orders',
          page: () => const AdminUserOrdersScreen(),
        ),
        GetPage(name: '/user_detail', page: () => const UserDetailScreen()),
        GetPage(name: '/admin-banners', page: () => const BannersScreen()),
        GetPage(name: '/users-feedback', page: () => UserFeedbackScreen()),
      ],
    );
  }
}
