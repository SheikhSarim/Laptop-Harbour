import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laptops_harbour/models/product_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final Function onTap;
  final VoidCallback? onFavoriteToggle;

  const ProductCard({Key? key, required this.product, required this.onTap, this.onFavoriteToggle})
    : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  void _loadFavoriteState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('favorite_${widget.product.id}') ?? false;
    });
  }

  void _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
    });
    await prefs.setBool('favorite_${widget.product.id}', isFavorite);
    if (widget.onFavoriteToggle != null) {
      widget.onFavoriteToggle!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                SizedBox(
                  width: double.infinity,
                  height: 130,
                  
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Product Name
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Or use start if needed
                  children: [
                    // Product Price
                    Text(
                       '\$${NumberFormat("#,##0.00", "en_US").format(widget.product.price)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.priceGreen,
                      ),
                    ),
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          widget.product.rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Heart Icon (top-left)
          Positioned(
            top: 4,
            left: 4,
            child: GestureDetector(
              onTap: _toggleFavorite,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppConstants.surfaceColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
          // Out of Stock Badge (top-right)
          if (!widget.product.inStock)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Out of Stock',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
