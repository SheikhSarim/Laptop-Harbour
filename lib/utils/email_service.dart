import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static Future<void> sendOrderConfirmation({
    required String toEmail,
    required String userName,
    required String orderId,
    required double totalAmount,
  }) async {
    String username = 'ahmadalidk270@gmail.com';
    String password = 'yuxb hqgv nxvm owbp'; 

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Laptop Harbour')
      ..recipients.add(toEmail)
      ..subject = 'Order Confirmation - Laptop Harbour'
      ..text = 'Hi $userName,\n\nThank you for your order! Your order ID is $orderId. Total: \u20B9$totalAmount\n\nWe appreciate your business!';

    try {
      await send(message, smtpServer);
    } catch (e) {
      print('Email send error: $e');
    }
  }
}
