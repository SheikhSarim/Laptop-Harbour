import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laptops_harbour/models/product_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:laptops_harbour/widgets/product_card.dart';
import 'package:laptops_harbour/controllers/product_controller.dart';
import 'package:get/get.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
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
    final ids = prefs.getKeys().where((k) => k.startsWith('favorite_')).toList();
    favoriteProductIds = ids
        .where((k) => prefs.getBool(k) == true)
        .map((k) => k.replaceFirst('favorite_', ''))
        .toList();
    final allProducts = productController.products;
    setState(() {
      wishlistProducts = allProducts
          .where((p) => favoriteProductIds.contains(p.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
            child: Text(
              'Your Wishlist',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: wishlistProducts.isEmpty
                ? const Center(child: Text('No products in wishlist.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: wishlistProducts.length,
                    itemBuilder: (context, index) {
                      final product = wishlistProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Get.toNamed('/productDetails/${product.id}');
                        },
                        onFavoriteToggle: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final key = 'favorite_${product.id}';
                          final isFav = prefs.getBool(key) ?? false;
                          await prefs.setBool(key, !isFav);
                          setState(() {
                            if (isFav) {
                              wishlistProducts.removeWhere((p) => p.id == product.id);
                            } else {
                              wishlistProducts.add(product);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
