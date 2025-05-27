import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/brand_controller.dart';
import 'package:laptops_harbour/models/brand_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class BrandManagementScreen extends StatelessWidget {
  BrandManagementScreen({super.key});

  final BrandController brandController = Get.put(BrandController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      backgroundColor: AppConstants.appBackgroundColor,
      body: Obx(() {
        if (brandController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (brandController.brands.isEmpty) {
          return const Center(child: Text('No brands found.'));
        }
        return ListView.builder(
          itemCount: brandController.brands.length,
          itemBuilder: (context, index) {
            final brand = brandController.brands[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppConstants.surfaceColor,
              child: ListTile(
                title: Text(brand.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: brand.logoUrl != null ? Image.network(brand.logoUrl!) : const Text('No Logo'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showBrandForm(context, brand: brand),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => brandController.deleteBrand(brand.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBrandForm(context),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: AppConstants.appSecondaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showBrandForm(BuildContext context, {BrandModel? brand}) {
    final nameController = TextEditingController(text: brand?.name ?? '');
    final logoUrlController = TextEditingController(text: brand?.logoUrl ?? '');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppConstants.appBackgroundColor,
          title: Text(brand == null ? 'Add Brand' : 'Edit Brand'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _textField(label: 'Brand Name', controller: nameController),
                _textField(label: 'Logo URL (Optional)', controller: logoUrlController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newBrand = BrandModel(
                  id: brand?.id ?? brandController.firestore.collection('brands').doc().id,
                  name: nameController.text,
                  logoUrl: logoUrlController.text.isNotEmpty ? logoUrlController.text : null,
                );

                if (brand == null) {
                  brandController.addBrand(newBrand);
                } else {
                  brandController.updateBrand(newBrand);
                }

                Get.back();
              },
              child: const Text('Save' ,  style: TextStyle(color: AppConstants.primaryColor),),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel' ,  style: TextStyle(color: AppConstants.accentDarkGrey),),
            ),
          ],
        );
      },
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
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
