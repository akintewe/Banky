import 'dart:convert';

import 'package:banky/views/mainLoginScreen.dart';
import 'package:banky/widgets/textfieldwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  @override
  void initState() {
    _emailController.addListener(_checkButton);

    // TODO: implement initState
    super.initState();
  }

  void _checkButton() {
    final email = _emailController.text;

    setState(() {
      _isButtonEnabled = email.isNotEmpty;
    });
  }

  Future<void> _sendPasswordResetEmail(String email) async {
    final apiUrl = 'https://api.banky.ca/v1/auth/forgot-password';

    final Map<String, dynamic> requestData = {
      "email": email,
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainLoginScreen()),
        );
        // Password reset email sent successfully
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody['message'];
        // Show success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } else {
        // Handle error cases here
        print(
            'Failed to send password reset email. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to send password reset email. Please try again later.'),
          ),
        );
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception occurred: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to send password reset email. Please check your internet connection.'),
        ),
      );
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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFieldWidget(
                  hint: 'Enter your email',
                  obscure: false,
                  controller: _emailController,
                ),
                SizedBox(height: 20),
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
                              String email = _emailController.text.trim();
                              if (email.isNotEmpty && email.contains('@')) {
                                // Call the function to send password reset email
                                _sendPasswordResetEmail(email);
                              } else {
                                Navigator.pop(context);
                                // Show an error message if email is invalid
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid email address.'),
                                  ),
                                );
                              }

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
                            'Reset Password',
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
}
