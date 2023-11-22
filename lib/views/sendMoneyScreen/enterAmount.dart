import 'dart:convert';
import 'package:banky/views/sendMoneyScreen/notsuccessful.dart';
import 'package:banky/views/sendMoneyScreen/successful.dart';
import 'package:http/http.dart' as http;

import 'package:banky/services/helpers/storeToken.dart';
import 'package:custom_pin_keyboard/custom_pin_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnterAmount extends StatefulWidget {
  final String? userFirstName;
  final String? userLastName;
  final String? userPhoneNumber;
  final String? userEmail;

  const EnterAmount({
    Key? key,
    this.userFirstName,
    this.userLastName,
    this.userPhoneNumber,
    this.userEmail,
  }) : super(key: key);

  @override
  State<EnterAmount> createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
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
          ),
        ),
        title: Text(
          'Enter Amount',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width * 0.89,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10), // Optional: You can adjust the border radius
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.3), // You can adjust the shadow color
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset:
                          Offset(0, 3), // changes the position of the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 40,
                        child: Image.asset(
                          'assets/images/image2.png',
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text('-------------------'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'First Name:',
                            style: TextStyle(
                                color: Color.fromRGBO(155, 155, 155, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.userFirstName ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Last Name:',
                            style: TextStyle(
                                color: Color.fromRGBO(155, 155, 155, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.userLastName ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phone Number:',
                            style: TextStyle(
                                color: Color.fromRGBO(155, 155, 155, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.userPhoneNumber ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email Address:',
                            style: TextStyle(
                                color: Color.fromRGBO(155, 155, 155, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.userEmail ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 20,
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
                      'Send Money',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
            ),
          )

          // ... other widgets for entering the amount
        ],
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
                    await _sendMoney(pin);
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

  Future<void> _sendMoney(String pin) async {
    final apiUrl =
        'https://api.banky.ca/v1/payment/wallet/transfer/single/create';
    final String userPin = pinController.text;
    final token = UserTokenManager.token;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'x-api-key':
            '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4', // Replace YOUR_API_KEY with the correct API key
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': widget.userEmail,
        'purpose': 'RrEF:cnse_jt48he21aefko', // Replace with your purpose
        'amount': int.parse(_amountController.text),
        'passcode': userPin,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('status') && responseBody['status']) {
        // Success: Navigate to successful page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessfulPage(amount: _amountController.text, name: widget.userLastName.toString(),),
          ),
        );
      } else {
        // API returned success=false
        // Navigate to not successful page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotSuccessful(),
          ),
        );
      }
    } else {
      // Handle other error cases
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      String errorMessage = 'Error: ${response.body}';

      if (errorBody.containsKey('error')) {
        errorMessage = errorBody['error'];
      }

      print(errorMessage);
      print('You have insufficient balance');

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(errorMessage),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotSuccessful(),
        ),
      );
    }
  }
}
