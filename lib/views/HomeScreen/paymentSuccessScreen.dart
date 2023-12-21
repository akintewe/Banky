import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String paymentLink;
  const PaymentSuccessScreen({super.key, required this.paymentLink});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.paymentLink),
      ),
    );
  }
}
