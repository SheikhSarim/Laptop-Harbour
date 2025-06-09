import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/cart_controller.dart';
import 'package:laptops_harbour/controllers/home_controller.dart';
import 'package:laptops_harbour/controllers/product_controller.dart';
import 'package:laptops_harbour/screens/user_panel/profile/profile_screen.dart';
import 'package:laptops_harbour/screens/user_panel/store/store.dart';
import 'package:laptops_harbour/screens/user_panel/wishlist/wishlist.dart';
import 'package:laptops_harbour/utils/brand_card_carosuel.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:laptops_harbour/widgets/bottom_nav_bar.dart';
import 'package:laptops_harbour/widgets/carosuel_slider.dart';
import 'package:laptops_harbour/widgets/drawer.dart';
import 'package:laptops_harbour/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final CartController cartController = Get.find();
    homeController.fetchUserData();
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppConstants.primaryIconColor),
            onPressed: () {
              Get.toNamed('/searchscreen');
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  color: AppConstants.primaryIconColor,
                ),
                Positioned(
                  left: 0,
                  top: -1,
                  child: Obx(
                    () =>
                        cartController.cartItems.isNotEmpty
                            ? Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: AppConstants.appStatusBarColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${cartController.cartItems.length}',
                                  style: TextStyle(
                                    color: AppConstants.invertTextColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            )
                            : SizedBox.shrink(),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Get.toNamed('/cart');
            },
          ),
        ],
        backgroundColor: AppConstants.appBackgroundColor,
      ),
      drawer: DrawerWidget(),
      body: Obx(() {
        switch (homeController.selectedTabIndex.value) {
          case 0:
            return const _HomeTabContent();
          case 1:
            return Store();
          case 2:
            return WishlistScreen();
          case 3:
            return ProfileScreen(); 
          default:
            return const _HomeTabContent();
        }
      }),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  const _HomeTabContent();

  Future<List<String>> _fetchBannerImages() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('banners').get();
    return snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());
    return FutureBuilder<List<String>>(
      future: _fetchBannerImages(),
      builder: (context, snapshot) {
        final images = snapshot.data ?? [];
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Discover",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryTextColor,
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator())
              else if (images.isNotEmpty)
                CarouselWidget(images: images)
              else
                const SizedBox.shrink(),
              SizedBox(height: 20),
              BrandCardCarousel(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/storescreenDrawer');
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Divider(height: 1, color: Colors.grey[300]),
              SizedBox(height: 10),
              Obx(() {
                if (productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (productController.products.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                final limitedProducts =
                    productController.products.take(4).toList();

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: limitedProducts.length,
                  itemBuilder: (context, index) {
                    final product = limitedProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Get.toNamed('/productDetails/${product.id}');
                      },
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
