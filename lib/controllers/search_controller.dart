import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var searchResults = <ProductModel>[].obs;
  var isLoading = false.obs;

  // Fetch all products from Firestore
  Future<void> fetchAllProducts() async {
    isLoading.value = true;
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    searchResults.value = snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
        .toList();
    isLoading.value = false;
  }

  // Search by product name (case-sensitive, prefix match)
  Future<void> searchByName(String query) async {
    if (query.isEmpty) {
      await fetchAllProducts();
      return;
    }
    isLoading.value = true;
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    searchResults.value = snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
        .toList();
    isLoading.value = false;
  }

  // Filter by category
  Future<void> filterByCategory(String category) async {
    isLoading.value = true;
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    searchResults.value = snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
        .toList();
    isLoading.value = false;
  }

  // Clear results and show all
  Future<void> clearResults() async {
    await fetchAllProducts();
  }
}
