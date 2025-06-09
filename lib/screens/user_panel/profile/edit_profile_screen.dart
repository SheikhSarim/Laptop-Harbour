import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool _loading = false;
  String? _email;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        _nameController.text = data['username'] ?? '';
        _contactController.text = data['contactNumber'] ?? data['contact'] ?? '';
        if (!_isDisposed) {
          setState(() {
            _email = user.email;
          });
        } else {
          _email = user.email;
        }
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isDisposed) setState(() { _loading = true; });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'username': _nameController.text.trim(),
        'contact': _contactController.text.trim(),
      });
      Get.snackbar('Profile Updated', 'Your profile information has been updated.', snackPosition: SnackPosition.BOTTOM);
      Get.back();
    }
    if (!_isDisposed) setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: AppConstants.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Name required' : null,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.trim().isEmpty ? 'Contact number required' : null,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      enabled: false,
                      initialValue: _email ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Email (cannot change)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.appButtonColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Save Changes', style: TextStyle(fontSize: 16 , color: AppConstants.invertTextColor) , ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
