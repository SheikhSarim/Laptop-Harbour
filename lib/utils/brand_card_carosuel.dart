import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/brand_controller.dart';
import 'package:laptops_harbour/widgets/brand_card_widget.dart';

class BrandCardCarousel extends StatelessWidget {
  const BrandCardCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());

    return Obx(() {
      if (controller.brands.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Top Brands',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: controller.currentIndex.value > 0
                    ? () {
                        controller.setCurrentIndex(
                          controller.currentIndex.value - 1,
                        );
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: controller.currentIndex.value <
                        controller.brands.length - 1
                    ? () {
                        controller.setCurrentIndex(
                          controller.currentIndex.value + 1,
                        );
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView.separated(
              controller: controller.scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: controller.brands.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final brand = controller.brands[index];
                return BrandCardWidget(brand: brand , cardWidth: 160,);
              },
            ),
          ),
        ],
      );
    });
  }
}
