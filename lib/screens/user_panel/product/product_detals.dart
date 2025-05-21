import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laptops_harbour/controllers/home_controller.dart';
import 'package:laptops_harbour/models/user_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:laptops_harbour/utils/helpers/add_review_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laptops_harbour/controllers/product_controller.dart';
import 'package:laptops_harbour/models/product_model.dart';
import 'package:laptops_harbour/controllers/cart_controller.dart';
import 'package:laptops_harbour/models/cart_item.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.put(CartController());
  bool isFavorite = false;
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    homeController.fetchUserData();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('favorite_${widget.productId}') ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
    });
    await prefs.setBool('favorite_${widget.productId}', isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.primaryIconColor),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // Fallback to the regular Navigator
            } else {
              Get.back(); // Use GetX back navigation
            }
          },
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Product Details',
          style: TextStyle(color: AppConstants.primaryTextColor),
        ),
        backgroundColor: AppConstants.appBackgroundColor,
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ProductModel? product = productController.products
            .firstWhereOrNull((p) => p.id == widget.productId);

        if (product == null) {
          return const Center(child: Text('Product not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 380,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (product.imageUrl.isNotEmpty)
                      Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 100),
                      ),
                    if (product.imageUrl.isEmpty)
                      const Icon(Icons.broken_image, size: 100),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      double rating = product.rating;
                      IconData icon;
                      if (rating >= index + 1) {
                        icon = Icons.star;
                      } else if (rating > index && rating < index + 1) {
                        icon = Icons.star_half;
                      } else {
                        icon = Icons.star_border;
                      }
                      return Icon(icon, color: Colors.amber, size: 20);
                    }),
                  ),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('In stock: ${product.inStock ? 'Yes' : 'No'}'),
              const SizedBox(height: 16),
              Text(product.description),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                  ), // Removes border
                ),
                child: ExpansionTile(
                  title: Text(
                    'Specifications:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  children:
                      product.specifications
                          .map(
                            (spec) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 4.0,
                              ),
                              child: Text('• $spec'),
                            ),
                          )
                          .toList(),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: 'Price: ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              '\$${NumberFormat("#,##0.00", "en_US").format(product.price)}',
                          style: TextStyle(
                            color: AppConstants.priceGreen,
                          ), // Value in green
                        ),
                      ],
                    ),
                  ),

                  Material(
                    child: Container(
                      width: Get.width / 2,
                      height: Get.height / 18,
                      decoration: BoxDecoration(
                        color: AppConstants.appButtonColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          final ProductModel? product = productController.products.firstWhereOrNull((p) => p.id == widget.productId);
                          if (product != null) {
                            cartController.addToCart(CartItem(
                              productId: product.id,
                              title: product.name,
                              imageUrl: product.imageUrl,
                              price: product.price,
                            ));
                            Get.snackbar('Added to Cart', '${product.name} added to cart!', snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        child: Text(
                          "ADD TO CART",
                          style: TextStyle(
                            color: AppConstants.appSecondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'User Reviews:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final firebaseUser = FirebaseAuth.instance.currentUser;

                      if (firebaseUser != null) {
                        final userModel = await UserModel.getUserFromFirestore(
                          firebaseUser.uid,
                        );

                        if (userModel != null) {
                          showAddReviewDialog(context, product, userModel);
                        } else {
                          Get.snackbar(
                            'Error',
                            'User data not found in Firestore',
                          );
                        }
                      } else {
                        Get.snackbar(
                          'Login Required',
                          'Please log in to add a review',
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.add_comment,
                      size: 24.0, // Customize the icon size
                      color: AppConstants.invertTextColor, // Icon color
                    ),
                    label: const Text(
                      "Add Review",
                      style: TextStyle(
                        fontSize: 16.0, // Customize font size
                        fontWeight: FontWeight.bold, // Text weight
                        color: AppConstants.invertTextColor, // Text color
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppConstants.invertTextColor,
                      backgroundColor: AppConstants.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5, // Shadow effect
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (product.reviews.isEmpty)
                const Text('No reviews yet.')
              else
                Column(
                  children:
                      product.reviews
                          .map(
                            (review) => ListTile(
                              title: Text(review.username),
                              subtitle: Text(review.reviewText),
                              trailing: Text('${review.rating}/5'),
                            ),
                          )
                          .toList(),
                ),
            ],
          ),
        );
      }),
     
    );
  }
}
