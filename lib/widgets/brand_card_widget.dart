import 'package:flutter/material.dart';
import 'package:laptops_harbour/models/brand_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class BrandCardWidget extends StatelessWidget {
  final BrandModel brand;
  final double cardWidth;

  const BrandCardWidget({
    super.key,
    required this.brand,
    this.cardWidth = 140, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => BrandDetailsScreen(brand: brand));
      },
      child: SizedBox(
        width: cardWidth, 
        child: Card(
          elevation: 0,
          color: AppConstants.appBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child:
                    brand.logoUrl != null && brand.logoUrl!.isNotEmpty
                        ? Image.network(
                          brand.logoUrl!,
                          width: double.infinity,
                          height: 126,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          width: double.infinity,
                          height: 126,
                          color: Colors.grey,
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
              ),
              
              Container(
                width: double.infinity,
                color: AppConstants.appBackgroundColor,
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    brand.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
