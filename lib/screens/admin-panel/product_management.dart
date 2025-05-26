import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/admin_controller.dart';
import 'package:laptops_harbour/models/product_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final AdminController adminController = Get.put(AdminController());

  @override
  void initState() {
    super.initState();
    adminController.fetchBrands();
    adminController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.appBackgroundColor,
      body: Obx(() {
        if (adminController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (adminController.products.isEmpty) {
          return const Center(child: Text('No products found.'));
        }
        return ListView.builder(
          itemCount: adminController.products.length,
          itemBuilder: (context, index) {
            final product = adminController.products[index];
            final brand = adminController.brands.firstWhereOrNull(
              (b) => b.id == product.brandId,
            );

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppConstants.surfaceColor,
              child: Stack(
                children: [
                  ListTile(
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Brand: ${brand?.name ?? 'Unknown'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showProductForm(context, product: product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => adminController.deleteProduct(product.id),
                        ),
                      ],
                    ),
                  ),
                  if (!product.inStock)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Out of Stock',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(context),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: AppConstants.appSecondaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProductForm(BuildContext context, {ProductModel? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    final imageUrlController = TextEditingController(text: product?.imageUrl ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final specController = TextEditingController(
      text: product?.specifications.join(', ') ?? '',
    );
    final categoryController = TextEditingController(text: product?.category ?? '');
    final quantityController = TextEditingController(
      text: product != null ? product.quantity.toString() : '',
    );

    String selectedBrandId = product?.brandId ?? '';
    adminController.fetchBrands();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppConstants.appBackgroundColor,
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _textField(label: 'Name', controller: nameController),
                Obx(() {
                  final brands = adminController.brands;
                  if (brands.isEmpty) return const CircularProgressIndicator();
                  return DropdownButtonFormField<String>(
                    value: selectedBrandId.isNotEmpty ? selectedBrandId : null,
                    decoration: const InputDecoration(labelText: 'Brand'),
                    items: brands.map((brand) {
                      return DropdownMenuItem<String>(
                        value: brand.id,
                        child: Text(brand.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedBrandId = value!;
                    },
                  );
                }),
                _textField(label: 'Description', controller: descriptionController),
                _textField(label: 'Image URL', controller: imageUrlController),
                _textField(label: 'Price', controller: priceController, isNumber: true),
                _textField(label: 'Quantity', controller: quantityController, isNumber: true),
                _textField(label: 'Specifications (comma-separated)', controller: specController),
                _textField(label: 'Category', controller: categoryController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newProduct = ProductModel(
                  id: product?.id ?? adminController.generateProductId(),
                  name: nameController.text,
                  brandId: selectedBrandId,
                  description: descriptionController.text,
                  imageUrl: imageUrlController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  specifications: specController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  rating: product?.rating ?? 0.0,
                  reviews: product?.reviews ?? [],
                  category: categoryController.text,
                );

                if (product == null) {
                  adminController.addProduct(newProduct);
                } else {
                  adminController.updateProduct(newProduct);
                }

                Get.back();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      cursorColor: AppConstants.primaryColor,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppConstants.primaryColor, width: 2.0),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
