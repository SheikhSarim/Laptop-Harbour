import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:laptops_harbour/widgets/product_card.dart';
import 'package:laptops_harbour/controllers/search_controller.dart'
    as custom_search;

class SearchScreen extends StatelessWidget {
  final custom_search.SearchController searchController = Get.put(
    custom_search.SearchController(),
  );
  final TextEditingController searchTextController = TextEditingController();

  SearchScreen({super.key}) {
    Future.microtask(() => searchController.fetchAllProducts());
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
        centerTitle: true,
        title: const Text(
          'SEARCH',
          style: TextStyle(color: AppConstants.primaryTextColor),
        ),
        backgroundColor: AppConstants.appBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchTextController,
                  decoration: InputDecoration(
                    hintText: 'Search laptops by name (e.g. MacBook, Asus)',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        searchController.searchByName(
                          searchTextController.text.trim(),
                        );
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onSubmitted: (value) {
                    searchController.searchByName(value.trim());
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _CategoryChip(
                        label: 'All',
                        chipColor: AppConstants.appStatusBarColor,
                        textColor: AppConstants.invertTextColor,
                        onTap: () {
                          searchController.fetchAllProducts();
                        },
                      ),
                      _CategoryChip(
                        label: 'Gaming',
                        chipColor: AppConstants.appStatusBarColor,
                        textColor: AppConstants.invertTextColor,
                        onTap:
                            () => searchController.filterByCategory('Gaming'),
                      ),
                      _CategoryChip(
                        label: 'Business',
                        chipColor: AppConstants.appStatusBarColor,
                        textColor: AppConstants.invertTextColor,
                        onTap:
                            () => searchController.filterByCategory('Business'),
                      ),
                      _CategoryChip(
                        label: 'Student',
                        chipColor: AppConstants.appStatusBarColor,
                        textColor: AppConstants.invertTextColor,
                        onTap:
                            () => searchController.filterByCategory('Student'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (searchController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (searchController.searchResults.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          childAspectRatio: 0.8,
                        ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searchController.searchResults.length,
                    itemBuilder: (context, index) {
                      final product = searchController.searchResults[index];

                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            Get.toNamed('/productDetails/${product.id}');
                          },
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color chipColor;
  final Color textColor;

  const _CategoryChip({
    required this.label,
    required this.onTap,
    this.chipColor = AppConstants.appButtonColor,
    this.textColor = AppConstants.invertTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label, style: TextStyle(color: textColor)),
        backgroundColor: chipColor,
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppConstants.primaryColor, width: 1),
        ),
        elevation: 0,
      ),
    );
  }
}
