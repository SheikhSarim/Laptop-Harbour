import 'package:flutter/material.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: AppConstants.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Information Collection\nWe collect information you provide directly to us when you use our app, such as your name, contact details, and order information.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '2. Use of Information\nWe use your information to provide, maintain, and improve our services, and to communicate with you about your orders and updates.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '3. Data Security\nWe implement security measures to protect your information. However, no method of transmission over the Internet is 100% secure.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '4. Sharing of Information\nWe do not share your personal information with third parties except as required by law or to provide our services.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '5. Changes to Policy\nWe may update this privacy policy from time to time. Continued use of the app after changes signifies your acceptance.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '6. Contact\nFor questions about this policy, please contact our support team.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
