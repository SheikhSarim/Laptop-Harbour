import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/models/brand_model.dart';
import 'package:laptops_harbour/models/product_model.dart';

class AdminController extends GetxController {
  // Observable list of products and loading state
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxList<BrandModel> brands = <BrandModel>[].obs;

  // Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<void> fetchBrands() async {
    try {
      final querySnapshot = await firestore.collection('brands').get();
      brands.value =
          querySnapshot.docs
              .map((doc) => BrandModel.fromMap(doc.id, doc.data()))
              .toList();
    } catch (e) {
      print('Error fetching brands: $e');
    }
  }

  // Fetch products from Firestore
  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      // Fetch products from Firestore
      final querySnapshot = await firestore.collection('products').get();
      // Map Firestore documents to ProductModel instances
      products.value =
          querySnapshot.docs
              .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
              .toList();
      isError.value = false;
    } catch (e) {
      // Handle error (e.g., network issue)
      print('Error fetching products: $e');
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  // Add a product to Firestore
  void addProduct(ProductModel product) async {
    try {
      await firestore
          .collection('products')
          .doc(product.id)
          .set(product.toMap());
      products.add(product);
    } catch (e) {
      print('Error adding product: $e');
      // You can handle an error state here if necessary
    }
  }

  // Update a product in Firestore
  void updateProduct(ProductModel product) async {
    try {
      await firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product; // Update the list
      }
    } catch (e) {
      print('Error updating product: $e');
      // Handle error state if needed
    }
  }

  // Delete a product from Firestore
  void deleteProduct(String id) async {
    try {
      await firestore.collection('products').doc(id).delete();
      products.removeWhere((product) => product.id == id);
    } catch (e) {
      print('Error deleting product: $e');
      // Handle error state if needed
    }
  }

  // Generate a new product ID (based on Firestore document ID)
  String generateProductId() {
    return firestore.collection('products').doc().id;
  }

  // Optionally, handle error state if needed
  void setErrorState(bool value) {
    isError.value = value;
  }
}
