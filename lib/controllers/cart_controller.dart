import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var couponApplied = false.obs;
  var couponCode = ''.obs;
  final String coupon = 'sarim123';
  final double couponDiscount = 0.1; // 10% discount

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void addToCart(CartItem item) {
    int index = cartItems.indexWhere((e) => e.productId == item.productId);
    if (index >= 0) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(item);
    }
    saveCart();
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((e) => e.productId == productId);
    saveCart();
  }

  void increaseQuantity(String productId) {
    int index = cartItems.indexWhere((e) => e.productId == productId);
    if (index >= 0) {
      cartItems[index] = CartItem(
        productId: cartItems[index].productId,
        title: cartItems[index].title,
        imageUrl: cartItems[index].imageUrl,
        price: cartItems[index].price,
        quantity: cartItems[index].quantity + 1,
      );
      saveCart();
    }
  }

  void decreaseQuantity(String productId) {
    int index = cartItems.indexWhere((e) => e.productId == productId);
    if (index >= 0 && cartItems[index].quantity > 1) {
      cartItems[index] = CartItem(
        productId: cartItems[index].productId,
        title: cartItems[index].title,
        imageUrl: cartItems[index].imageUrl,
        price: cartItems[index].price,
        quantity: cartItems[index].quantity - 1,
      );
      saveCart();
    }
  }

  double get totalPrice {
    double total = cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
    if (couponApplied.value) {
      total = total * (1 - couponDiscount);
    }
    return total;
  }

  void applyCoupon(String code) {
    if (code == coupon) {
      couponApplied.value = true;
      couponCode.value = code;
    } else {
      couponApplied.value = false;
      couponCode.value = '';
    }
  }

  void clearCart() {
    cartItems.clear();
    couponApplied.value = false;
    couponCode.value = '';
    saveCart();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartJson = cartItems.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('cart', cartJson);
    await prefs.setBool('couponApplied', couponApplied.value);
    await prefs.setString('couponCode', couponCode.value);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList('cart');
    if (cartJson != null) {
      cartItems.value = cartJson.map((e) => CartItem.fromJson(jsonDecode(e))).toList();
    }
    couponApplied.value = prefs.getBool('couponApplied') ?? false;
    couponCode.value = prefs.getString('couponCode') ?? '';
  }
}
