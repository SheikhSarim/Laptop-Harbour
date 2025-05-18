import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout() async {
  try {
    
    await FirebaseAuth.instance.signOut();

    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 

    
    Get.offAll(() => LoginScreen()); 
  } catch (e) {
    print('Error signing out: $e');
  }
}
