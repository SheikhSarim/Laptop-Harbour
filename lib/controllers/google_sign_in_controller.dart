
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:laptops_harbour/models/user_model.dart';
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

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          
          String username = user.displayName ?? 'Unknown User';
          String email = user.email ?? 'No email provided';
          String contactNumber = user.phoneNumber ?? 'No phone number';

          
          UserModel userModel = UserModel(
            userId: user.uid,
            username: username,
            email: email,
            contactNumber: contactNumber,
            isAdmin: false,
            createdOn: DateTime.now(),
          );

          
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());

         
          isLoading.value = false;
          Get.offAll(() => const HomeScreen());

                    // Check if user is admin
          // final DocumentSnapshot doc =
          //     await FirebaseFirestore.instance
          //         .collection('users')
          //         .doc(user.uid)
          //         .get();

          // bool isAdmin = false;
          // if (doc.exists) {
          //   final data = doc.data() as Map<String, dynamic>;
          //   isAdmin = data['isAdmin'] ?? false;
          // }

          // isLoading.value = false;
          // Get.offAll(() => isAdmin ? AdminDashboard() : const HomeScreen());
        } else {
          
          isLoading.value = false;
          Get.snackbar('Error', 'User authentication failed');
        }
      } else {
        
        isLoading.value = false;
        Get.snackbar('Error', 'Google sign-in failed');
      }
    } catch (e) {
      
      isLoading.value = false;
      print("Error: $e");
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }
}
