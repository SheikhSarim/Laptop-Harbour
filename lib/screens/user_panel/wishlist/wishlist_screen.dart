import 'package:flutter/material.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laptops_harbour/models/product_model.dart';
import 'package:laptops_harbour/widgets/product_card.dart';
import 'package:laptops_harbour/controllers/product_controller.dart';
import 'package:get/get.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<String> favoriteProductIds = [];
  late final ProductController productController;
  List<ProductModel> wishlistProducts = [];

  @override
  void initState() {
    super.initState();
    productController = Get.put(ProductController());
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final ids =
        prefs.getKeys().where((k) => k.startsWith('favorite_')).toList();
    favoriteProductIds =
        ids
            .where((k) => prefs.getBool(k) == true)
            .map((k) => k.replaceFirst('favorite_', ''))
            .toList();
    final allProducts = productController.products;
    setState(() {
      wishlistProducts =
          allProducts.where((p) => favoriteProductIds.contains(p.id)).toList();
    });
  }

  void _toggleFavorite(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'favorite_${product.id}';
    await prefs.setBool(key, false); 

    setState(() {
      wishlistProducts.removeWhere((p) => p.id == product.id);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.primaryIconColor),
          onPressed: () {
            Get.back();
          },
        ),
        automaticallyImplyLeading: true,

        backgroundColor: AppConstants.appBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
            child: Text(
              'Your Wishlist',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child:
                wishlistProducts.isEmpty
                    ? const Center(child: Text('No products in wishlist.'))
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: wishlistProducts.length,
                      itemBuilder: (context, index) {
                        final product = wishlistProducts[index];
                        return ProductCard(
                           key: ValueKey(product.id),
                          product: product,
                          onTap: () {
                            Get.toNamed('/productDetails/${product.id}');
                          },
                          onFavoriteToggle: () => _toggleFavorite(product),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
