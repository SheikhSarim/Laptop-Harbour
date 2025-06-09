import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/models/brand_model.dart';

class BrandController extends GetxController {
  var brands = <BrandModel>[].obs;
  var isLoading = true.obs;

  var currentIndex = 0.obs;
  final ScrollController scrollController = ScrollController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBrands(); 
  }

  // Method to fetch brands from Firestore
  Future<void> fetchBrands() async {
    try {
      isLoading(true);
      var snapshot = await firestore.collection('brands').get();
      var brandList =
          snapshot.docs
              .map(
                (doc) => BrandModel.fromMap(doc.id, doc.data()),
              ) 
              .toList();
      brands.assignAll(brandList);
    } catch (e) {
      print('Error fetching brands: $e');
    } finally {
      isLoading(false);
    }
  }

  // 👇 Add this setter
  void setCurrentIndex(int index) {
    currentIndex.value = index;
    scrollToIndex(index);
  }

  // 👇 Smooth scroll to item
  void scrollToIndex(int index) {
    final position = index * 152.0; 
    scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Add a brand to Firestore
  Future<void> addBrand(BrandModel brand) async {
    try {
      await firestore.collection('brands').doc(brand.id).set(brand.toMap());
      brands.add(brand);
    } catch (e) {
      print('Error adding brand: $e');
    }
  }

  // Update a brand in Firestore
  Future<void> updateBrand(BrandModel brand) async {
    try {
      await firestore.collection('brands').doc(brand.id).update(brand.toMap());
      final index = brands.indexWhere((b) => b.id == brand.id);
      if (index != -1) {
        brands[index] = brand;
      }
    } catch (e) {
      print('Error updating brand: $e');
    }
  }

  // Delete a brand from Firestore
  Future<void> deleteBrand(String id) async {
    try {
      await firestore.collection('brands').doc(id).delete();
      brands.removeWhere((brand) => brand.id == id);
    } catch (e) {
      print('Error deleting brand: $e');
    }
  }
}
