import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptops_harbour/models/product_model.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); 
  }

  // 🔄 Fetch all products from Firestore
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final snapshot = await firestore.collection('products').get();

      var productList =
          snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
              .toList();

      products.assignAll(productList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
