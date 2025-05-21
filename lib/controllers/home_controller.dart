import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
 
  var selectedTabIndex = 0.obs;
  var username = 'Guest'.obs;
  var email = 'example@email.com'.obs;

 
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          username.value = userDoc.get('username') ?? 'Guest';
          email.value = user.email ?? 'No email';
        } else {
          print("User document does not exist for UID: ${user.uid}");
        }
      } else {
        print("No user logged in");
      }
    } catch (e) {
      print("Error fetching username: $e");
    }
  }
}
