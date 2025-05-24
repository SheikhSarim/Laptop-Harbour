import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptops_harbour/models/banner_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class BannersScreen extends StatefulWidget {
  const BannersScreen({super.key});

  @override
  State<BannersScreen> createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {
  final TextEditingController _imageController = TextEditingController();

  Future<List<BannerModel>> _fetchBanners() async {
    final snapshot = await FirebaseFirestore.instance.collection('banners').get();
    return snapshot.docs
        .map((doc) => BannerModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> _addBanner(String imageUrl) async {
    await FirebaseFirestore.instance.collection('banners').add({'imageUrl': imageUrl});
    setState(() {});
  }

  Future<void> _deleteBanner(String id) async {
    await FirebaseFirestore.instance.collection('banners').doc(id).delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Banners'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imageController,
                    decoration: const InputDecoration(
                      labelText: 'Banner Image URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (_imageController.text.trim().isNotEmpty) {
                      await _addBanner(_imageController.text.trim());
                      _imageController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<BannerModel>>(
                future: _fetchBanners(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No banners found.'));
                  }
                  final banners = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return Card(
                        color: AppConstants.surfaceColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  banner.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 40)),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await _deleteBanner(banner.id);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
