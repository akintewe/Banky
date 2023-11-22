import 'dart:convert';

import 'package:banky/services/helpers/storeId.dart';
import 'package:banky/services/helpers/storeToken.dart';
import 'package:banky/services/helpers/storeUsername.dart';
import 'package:banky/views/HomeScreen/homepage.dart';
import 'package:banky/views/resetPassword.dart';
import 'package:http/http.dart' as http;
import 'package:banky/views/loginScreen.dart';
import 'package:banky/widgets/regTitle.dart';
import 'package:banky/widgets/textfieldwidget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MainLoginScreen extends StatefulWidget {
  const MainLoginScreen({super.key});

  @override
  State<MainLoginScreen> createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  @override
  void initState() {
    _emailController.addListener(_checkButton);
    _passwordController.addListener(_checkButton);
    _getUserDetails();
    // TODO: implement initState
    super.initState();
  }

  void _checkButton() {
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _isButtonEnabled = email.isNotEmpty && password.isNotEmpty;
    });
  }

  Future<void> _signIn() async {
    final apiUrl = 'https://api.banky.ca/v1/auth/login';

    final Map<String, dynamic> requestData = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "device": {"model": "iPhone X", "deviceId": "1234567890abcdef"}
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
        // User authenticated successfully
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        dynamic status = responseBody['status'];
        if (status == 'success' || status == true) {
          String token = responseBody['token'];
          print('Token: $token');
          UserTokenManager.setToken(token);

          // Navigate to the home page or perform other actions upon successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (status == 'pending' || status == false) {
          Navigator.pop(context);
          // Handle pending status, for example, show an error message
          String errorMessage = responseBody['error'];
          // Show error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage.toString()),
            ),
          );
        }
      } else if (response.statusCode == 403) {
        Navigator.pop(context);
        // Handle error cases here
        print('Failed to sign in. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This account isnt in our record please register'),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      // Handle network errors or other exceptions
      print('Exception occurred: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to sign in. Please check your internet connection.'),
        ),
      );
    }
  }

  Future<void> _getUserDetails() async {
    try {
      final apiUrl = 'https://api.banky.ca/v1/user/profile';
      final token = UserTokenManager.token;

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key':
              '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4',
        },
      );

      if (mounted) {
        if (response.statusCode == 200) {
          print('Getting user info');
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData.containsKey('status') && responseData['status']) {
            final Map<String, dynamic> userDetails = responseData['user'];

            // Print user details to the console
            print('User ID: ${userDetails['_id']}');
            print('First Name: ${userDetails['firstName']}');
            print('Last Name: ${userDetails['lastName']}');
            print('Email: ${userDetails['email']}');
            String userName = userDetails['firstName'];
            UserNameManager.setUserName(userName);
            String userId = userDetails['_id'];

            print('userName: $userName');
            print('userId from here: $userId');
            UserIdManager.setId(userId);

            // Add more details as needed

            // Do any additional processing or navigation here
          } else {
            // Handle API error
            print('Error: ${responseData['message']}');
          }
        } else {
          // Handle other HTTP status codes
          print('HTTP Error: ${response.statusCode}');
        }

        // Dismiss the loading dialog
      }
    } catch (e) {
      if (mounted) {
        // Handle other errors
        print('Error: $e');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to retrieve user details. Please check your internet connection.'),
          ),
        );

        // Dismiss the loading dialog
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Work without limits',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const RegTitle(
              title: 'Your email address',
            ),
            TextFieldWidget(
              hint: 'fjhshsk@gmail.com',
              obscure: false,
              controller: _emailController,
            ),
            const RegTitle(title: 'Enter your password'),
            TextFieldWidget(
              hint: '. . . . . . . .',
              obscure: true,
              controller: _passwordController,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPassword()));
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color.fromRGBO(16, 47, 84, 1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
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
                                child: LoadingAnimationWidget.flickr(
                                    leftDotColor:
                                        const Color.fromRGBO(54, 109, 233, 1),
                                    rightDotColor: Colors.white,
                                    size: 30),
                              );
                            },
                          );

                          await _signIn();
                          await _getUserDetails();

                          // Call the signUp function

                          // Dismiss the loading indicator

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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
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
            const SizedBox(
              height: 20,
            ),
            const Text(
              'or',
              style: TextStyle(
                  color: Color.fromRGBO(231, 232, 239, 1), fontSize: 19),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 380,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromRGBO(231, 232, 239, 1), width: 1),
                        borderRadius: BorderRadius.circular(
                            30), // Set your desired border radius here
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/gg.png'),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Login with Google',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 380,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromRGBO(231, 232, 239, 1), width: 1),
                        borderRadius: BorderRadius.circular(
                            30), // Set your desired border radius here
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/gg.png'),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Login with Apple',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: const TextStyle(
                    color: Color.fromRGBO(151, 151, 151, 1),
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        color: Color.fromRGBO(16, 47, 84, 1),
                        fontSize: 16,
                      ),
                      // Add your registration logic here
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
