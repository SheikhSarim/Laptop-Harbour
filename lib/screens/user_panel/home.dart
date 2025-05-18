import 'package:flutter/material.dart';
import 'package:laptops_harbour/screens/auth/logout.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ), // App main text color
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ), // App main text color
            onPressed: () {
              logout();
            },
          ),
        ],
        backgroundColor:
            AppConstants.appBackgroundColor, // App background color
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              // child: RichText(
              //   text: TextSpan(
              //     children: [
              //       TextSpan(
              //         text: 'Discover the new ',
              //         style: TextStyle(
              //           fontSize: 32,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black, // Main text color
              //         ),
              //       ),
              //       TextSpan(
              //         text: 'WAY',
              //         style: TextStyle(
              //           fontSize: 32,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.orange, // Main accent color
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Discover"), Icon(Icons.shopping_bag_rounded)],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Placeholder for Carousel Widget
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(child: Text('Carousel Placeholder')),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Brands',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('See all', style: TextStyle(color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 16),
                // Brand placeholders
                Row(
                  children: [
                    buildBrandCard('Apple'),
                    const SizedBox(width: 12),
                    buildBrandCard('ASUS'),
                    const SizedBox(width: 12),
                    buildBrandCard('HP'),
                  ],
                ),
              ],
            ),

            // // Placeholder for CityCardCarousel widget
            // Container(
            //   height: 150,
            //   color: Colors.grey[300],
            //   child: Center(child: Text('City Card Carousel Placeholder')),
            // ),
            SizedBox(height: 20),
            Text(
              'Popular Attractions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black, // Main text color
              ),
            ),
            SizedBox(height: 10),
            Divider(height: 1, color: Colors.grey[300]),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2, // 2 items per row
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3, // Adjust as needed for item shape
              children: List.generate(6, (index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text('Product $index')),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10.0,
        shape: CircularNotchedRectangle(),
        color: Colors.grey[200], // App container color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(0, Icons.home, 'Home'),
            _buildBottomNavItem(1, Icons.explore, 'Explore'),
            _buildBottomNavItem(2, Icons.account_circle, 'Profile'),
          ],
        ),
      ),
      // drawer: DrawerWidget(), // Drawer widget used
    );
  }

  // Helper method to build individual bottom navigation items
  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Placeholder for tab change logic
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.black, // Main text color when inactive
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.black, // Main text color when inactive
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBrandCard(String brandName) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400], // Placeholder for image/icon
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 8),
          Text(brandName, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
