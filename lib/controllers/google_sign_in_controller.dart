import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:laptops_harbour/models/user_model.dart';
import 'package:laptops_harbour/screens/admin-panel/admin_dashboard.dart';
import 'package:laptops_harbour/screens/user_panel/home.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        isLoading.value = false;
        Get.snackbar('Error', 'Google sign-in was cancelled');
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user == null) {
        isLoading.value = false;
        Get.snackbar('Error', 'User authentication failed');
        return;
      }

      // Check if user already exists
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (!userDoc.exists) {
        // Create a new user
        final newUser = UserModel(
          userId: user.uid,
          username: user.displayName ?? 'Unknown User',
          email: user.email ?? 'No email provided',
          contactNumber: user.phoneNumber ?? 'No phone number',
          isAdmin: false, // By default
          createdOn: DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(newUser.toMap());
      }

      // Read isAdmin flag (whether new or existing user)
      final userData =
          (await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get())
              .data();

      final isAdmin = userData?['isAdmin'] ?? false;

      isLoading.value = false;
      Get.offAll(() => isAdmin ? AdminDashboard() : const HomeScreen());
    } catch (e) {
      isLoading.value = false;
      print("Google Sign-In Error: $e");
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }
}
