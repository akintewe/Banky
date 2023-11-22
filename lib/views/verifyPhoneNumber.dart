import 'dart:async';

import 'package:banky/views/HomeScreen/homepage.dart';
import 'package:banky/widgets/textfieldwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyPhone extends StatefulWidget {
  final String phoneNumber;

  VerifyPhone({required this.phoneNumber});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  int _timerSeconds = 60;
  late Timer _timer;
  bool _isButtonEnabled = false;
  bool _isResendEnabled = false;
  @override
  void initState() {
    _verificationCodeController.addListener(_checkButton);
    _startTimer();
    // TODO: implement initState
    super.initState();
  }

  void _checkButton() {
    final verification = _verificationCodeController.text;

    setState(() {
      _isButtonEnabled = verification.isNotEmpty;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer.cancel();
          _isResendEnabled =
              true; // Enable the "Resend Verification Code" button
        }
      });
    });
  }

  void _resetTimer() {
    _timer.cancel();
    _timerSeconds = 60;
    _isResendEnabled = false;
    _startTimer();
  }

  Future<void> _resendVerificationCode() async {
    final apiUrl = 'https://api.banky.ca/v1/auth/resend-verification-code';

    final Map<String, dynamic> requestData = {
      "phoneNumber": widget.phoneNumber,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key':
              '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4', // Replace YOUR_API_KEY with the correct API key
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Verification code resent successfully, handle the response as needed
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(
            'Verification code resent successfully: ${responseBody['message']}');
        _showSnackBar('Verification code resent successfully');

        // You can navigate to the next screen or perform any actions here
      } else {
        // Handle error cases here
        print(
            'Failed to resend verification code. Status code: ${response.statusCode}');
        _showSnackBar('Failed to resend verification code');
        print('Response body: ${response.body}');
        // You can show an error message to the user or retry the resend
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception occurred: $e');
      // You can show an error message to the user or retry the resend
    }
  }

  Future<void> _verifyPhoneNumber(String verificationCode) async {
    final apiUrl = 'https://api.banky.ca/v1/auth/verify-phone';

    final Map<String, dynamic> requestData = {
      "phoneNumber": widget.phoneNumber,
      "verificationCode": verificationCode,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key':
              '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4', // Replace YOUR_API_KEY with the correct API key
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Phone number verified successfully, handle the response as needed
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print('Phone Number verified successfully: ${responseBody['message']}');
        _showSnackBar('Phone number verified successfully');

        // You can navigate to the next screen or perform any actions here
      } else {
        // Handle error cases here
        print(
            'Failed to verify phone number. Status code: ${response.statusCode}');
        _showSnackBar('Failed to Verify Phone number');
        print('Response body: ${response.body}');
        // You can show an error message to the user or retry the verification
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception occurred: $e');
      // You can show an error message to the user or retry the verification
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/logo-no-background.png',
                height: 30,
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Verify Phone Number',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Enter the verification code sent to ${widget.phoneNumber}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFieldWidget(
                  hint: 'Verification code',
                  obscure: false,
                  controller: _verificationCodeController,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_timerSeconds seconds left',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _isResendEnabled ? Colors.blue : Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: _isResendEnabled
                            ? () {
                                _resendVerificationCode();
                                _resetTimer();
                              }
                            : null,
                        child: Text(
                          'Resend Verification',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  _isResendEnabled ? Colors.blue : Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 380,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              String verificationCode =
                                  _verificationCodeController.text;
                              if (verificationCode.isNotEmpty) {
                                _verifyPhoneNumber(verificationCode);
                              } else {
                                // Show an error message to the user
                              }

                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );

                              // Do something when the button is clicked
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        primary: _isButtonEnabled
                            ? const Color.fromRGBO(16, 47, 84, 1)
                            : Colors.grey,
                        // Set the button's background color
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Verify',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 9,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
