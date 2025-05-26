import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:laptops_harbour/models/feedback_model.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  String _feedbackType = 'Suggestion';
  final TextEditingController _messageController = TextEditingController();
  bool _loading = false;

  final List<String> _types = [
    'Suggestion',
    'Bug Report',
    'General Feedback',
    'Question',
  ];

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to submit feedback.');
      setState(() {
        _loading = false;
      });
      return;
    }
    final feedbackRef =
        FirebaseFirestore.instance.collection('feedbacks').doc();
    final feedback = FeedbackModel(
      id: feedbackRef.id,
      userId: user.uid,
      type: _feedbackType,
      message: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );
    await feedbackRef.set(feedback.toMap());
    setState(() {
      _loading = false;
      _feedbackType = 'Suggestion';
      _messageController.clear();
    });
    Get.snackbar(
      'Thank you!',
      'Your feedback has been submitted.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstants.surfaceColor,
      colorText: AppConstants.primaryTextColor,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Feedback', style: TextStyle(color: Colors.black)),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        "We'd love to hear your thoughts on our app!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Feedback Type',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _feedbackType,
                        items:
                            _types
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _feedbackType = val);
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        dropdownColor: AppConstants.surfaceColor,
                        style: const TextStyle(
                          color: AppConstants.primaryTextColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Your Message',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _messageController,
                        cursorColor: AppConstants.primaryColor,
                        minLines: 5,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          hintText: 'Please enter your feedback here...',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Message required'
                                    : null,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.appButtonColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppConstants.invertTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
