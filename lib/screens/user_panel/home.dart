import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/cart_controller.dart';
import 'package:laptops_harbour/controllers/home_controller.dart';
import 'package:laptops_harbour/controllers/product_controller.dart';
import 'package:laptops_harbour/screens/user_panel/store/store.dart';
import 'package:laptops_harbour/screens/user_panel/wishlist.dart';
import 'package:laptops_harbour/utils/brand_card_carosuel.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:laptops_harbour/widgets/bottom_nav_bar.dart';
import 'package:laptops_harbour/widgets/carosuel_slider.dart';
import 'package:laptops_harbour/widgets/drawer.dart';
import 'package:laptops_harbour/widgets/product_card.dart';

final List<String> images = [
  'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/laptop-sale-template-design-df4be79b4d18b6c7fdabde8ec7780bce_screen.jpg?ts=1720168468',
  'https://t3.ftcdn.net/jpg/04/65/46/52/360_F_465465254_1pN9MGrA831idD6zIBL7q8rnZZpUCQTy.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCPW1oZLDImt54gJ05-SLdBZISkljbXbHBow&s',
];

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
              // Search();
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
                              // padding: EdgeInsets.all(4),
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
          // return const ProfileScreen();
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

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());

    final List<String> images = [
      'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/laptop-sale-template-design-df4be79b4d18b6c7fdabde8ec7780bce_screen.jpg?ts=1720168468',
      'https://t3.ftcdn.net/jpg/04/65/46/52/360_F_465465254_1pN9MGrA831idD6zIBL7q8rnZZpUCQTy.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCPW1oZLDImt54gJ05-SLdBZISkljbXbHBow&s',
    ];

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
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
          SizedBox(height: 20),
          CarouselWidget(images: images),
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
                  Get.toNamed('/storescreen');
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

            // Limit the products to a maximum of 6 for the home screen
            final limitedProducts = productController.products.take(4).toList();

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
  }
}
