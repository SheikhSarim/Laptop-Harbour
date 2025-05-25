import 'package:flutter/material.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
                'Terms & Conditions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Acceptance of Terms\nBy accessing and using this app, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '2. Use of Service\nYou agree to use the app only for lawful purposes and in a way that does not infringe the rights of, restrict or inhibit anyone else’s use and enjoyment of the app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '3. Modifications\nWe reserve the right to change these terms at any time. Continued use of the app signifies your acceptance of any adjusted terms.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '4. Limitation of Liability\nWe are not liable for any damages or losses resulting from your use of the app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '5. Contact\nFor any questions regarding these terms, please contact our support team.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
