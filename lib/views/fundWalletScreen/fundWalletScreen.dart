import 'package:banky/services/helpers/storeToken.dart';
import 'package:custom_pin_keyboard/custom_pin_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController newPinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          'Fund Wallet',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose a payment option:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Image.asset('assets/icons/palmpay.png'),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset('assets/icons/gpay.png'),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset('assets/icons/applepay.png'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Use card:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                tileColor: Color.fromRGBO(245, 245, 245, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                leading: Image.asset('assets/icons/Mcard.png'),
                title: Text('*********82768'),
                subtitle: Text('\$34,907.80'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Amount:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromRGBO(245, 245, 245, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '\$',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Amount',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      keyboardType: TextInputType.number,
                      // Other properties and handlers as needed
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(16, 47, 84, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: () {
                      _showPinKeyboardBottomSheet(context);
                    },
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPinKeyboardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Enter your pin',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 400,
                child: CustomPinKeyboard(
                  controller: pinController,
                  onCompleted: (pin) async {
                    Navigator.pop(context);
                    // Make API call to fund the wallet
                    await _fundWallet(pin);
                  },
                  indicatorBackground: Colors.black12,
                  buttonBackground: Colors.transparent,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 32 / 24,
                    fontSize: 24,
                    color: Color.fromRGBO(16, 47, 84, 1),
                  ),
                  additionalButton:
                      const Icon(Icons.ac_unit, color: Colors.blue),
                  onAdditionalButtonPressed: () {
                    // some additional action
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fundWallet(String pin) async {
    // Make API call to fund the wallet
    final apiUrl = 'https://api.banky.ca/v1/wallet/fund';
    final String userPin = pinController.text;
    final token = UserTokenManager.token; // Replace with your actual API key

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'x-api-key':
            '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4', // Replace YOUR_API_KEY with the correct API key
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "amount": _amountController.text,
        "currency": "cad",
        "passcode": userPin,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success response
      print('Wallet funded successfully');
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('paymentResult') &&
          responseBody['paymentResult'] is Map<String, dynamic>) {
        Map<String, dynamic> paymentResult =
            responseBody['paymentResult'] as Map<String, dynamic>;

        if (paymentResult.containsKey('payment') &&
            paymentResult['payment'] is Map<String, dynamic>) {
          Map<String, dynamic> payment =
              paymentResult['payment'] as Map<String, dynamic>;

          // Print payment details
          print('Payment ID: ${payment['id']}');
          print('Client Secret: ${payment['client_secret']}');
          print('Payment Link: ${payment['paymentLink']}');
          _launchPaymentLink(payment['paymentLink']);
        }
      }
    } else {
      // Handle error response
      print('Error funding wallet: ${response.statusCode}');
      print(response.body);
    }
    if (response.statusCode == 400 &&
        response.body.contains(
            'Please you have to set your passcode before proceeding')) {
      _showNewPinKeyboardBottomSheet(context);
    }
  }

  void _launchPaymentLink(String paymentLink) {
    launch(paymentLink);
  }

  void _showNewPinKeyboardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Enter your new pin',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 400,
                child: CustomPinKeyboard(
                  controller: newPinController,
                  onCompleted: (pin) async {
                    await _setNewPin(pin);
                    Navigator.pop(context);
                    _showPinKeyboardBottomSheet(context);
                    // Make API call to fund the wallet
                  },
                  indicatorBackground: Colors.black12,
                  buttonBackground: Colors.transparent,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 32 / 24,
                    fontSize: 24,
                    color: Colors.blue,
                  ),
                  additionalButton:
                      const Icon(Icons.ac_unit, color: Colors.blue),
                  onAdditionalButtonPressed: () {
                    // some additional action
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _setNewPin(String newPin) async {
    // Make API call to set the new pin
    final apiUrl = 'https://api.banky.ca/v1/user/passcode/create';
    final token = UserTokenManager.token; // Replace with your actual API key

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'x-api-key':
            '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4', // Replace YOUR_API_KEY with the correct API key
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "passcode": newPin,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success response
      print('New pin set successfully');
    } else {
      // Handle error response
      print('Error setting new pin: ${response.statusCode}');
      print(response.body);
    }
  }
}
