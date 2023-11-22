import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:banky/views/mainLoginScreen.dart';
import 'package:banky/views/verifyPhoneNumber.dart';
import 'package:banky/widgets/deviceClass.dart';

import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;

import 'package:banky/views/HomeScreen/homepage.dart';
import 'package:banky/widgets/regTitle.dart';
import 'package:banky/widgets/textfieldwidget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  bool _isButtonEnabled = false;
  DeviceInfo? _deviceInfo;
  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkButton);
    _passwordController.addListener(_checkButton);
    _getDeviceDetails();
    _selectedDate = DateTime.now();
  }

  Future<void> _getDeviceDetails() async {
    Map<String, String> deviceDetails = await getDeviceDetails();
    setState(() {
      _deviceInfo = DeviceInfo(
        model: deviceDetails['model'] ?? '',
        deviceId: deviceDetails['deviceId'] ?? '',
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromRGBO(
                16, 47, 84, 1), // Set your primary color here
            hintColor: const Color.fromRGBO(
                16, 47, 84, 1), // Set your accent color here
            colorScheme: ColorScheme.light(
              primary: const Color.fromRGBO(
                  16, 47, 84, 1), // Set your primary color here
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd MMM yyyy').format(_selectedDate!);
      });
    }
  }

  void _checkButton() {
    final email = _emailController.text;
    final password = _passwordController.text;
    final phoneNumber = _phoneController.text;

    setState(() {
      _isButtonEnabled =
          email.isNotEmpty && password.isNotEmpty && phoneNumber.isNotEmpty;
    });
  }

  Future<Map<String, String>> getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, String> deviceDetails = {};

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceDetails['model'] = androidInfo.model;
        deviceDetails['deviceId'] =
            androidInfo.androidId; // Unique device ID for Android
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceDetails['model'] = iosInfo.model;
        deviceDetails['deviceId'] =
            iosInfo.identifierForVendor; // Unique device ID for iOS
      }
    } catch (e) {
      print('Error getting device details: $e');
    }

    return deviceDetails;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _signUp() async {
    final apiUrl = 'https://api.banky.ca/v1/auth/register';

    final Map<String, dynamic> requestData = {
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "cpassword": _passwordController.text,
      "phoneNumber": _phoneController.text,
      "dateOfBirth": _dateController.text,
      "device": {"model": "iPhone X", "deviceId": "1234567890abcdef"}
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key':
              '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        // User registered successfully, navigate to the home page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyPhone(
                    phoneNumber: _phoneController.text,
                  )),
        );
        print('User registered successfully: ${jsonEncode(requestData)}');
      } else if (response.statusCode == 409) {
        Navigator.pop(context);
        _showSnackBar('User with this phone number or email already exists');

        // Handle error cases here
        print('Failed to sign up. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception occurred: $e');
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
              padding: const EdgeInsets.all(20.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const RegTitle(
                  title: 'First name',
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 100.0),
                  child: const RegTitle(
                    title: 'Last name',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: SizedBox(
                    height: 50,
                    width: 175,
                    child: TextField(
                      controller: _firstNameController,
                      style: TextStyle(color: Colors.black),
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Peter", // Set your hint text here
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(200, 199, 199, 1),
                            fontSize: 13),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(231, 232, 239, 1),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(231, 232, 239, 1),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: SizedBox(
                    height: 50,
                    width: 180,
                    child: TextField(
                      controller: _lastNameController,
                      style: TextStyle(color: Colors.black),
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Frank", // Set your hint text here
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(200, 199, 199, 1),
                            fontSize: 13),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(231, 232, 239, 1),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(231, 232, 239, 1),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const RegTitle(
              title: 'Date of birth',
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month),
                        hintText: 'Select Date',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(200, 199, 199, 1),
                            fontSize: 13),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(231, 232, 239, 1),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(231, 232, 239, 1),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const RegTitle(
              title: 'Email address',
            ),
            TextFieldWidget(
              hint: 'fjhshsk@gmail.com',
              obscure: false,
              controller: _emailController,
            ),
            const RegTitle(title: 'Phone number'),
            TextFieldWidget(
              hint: '+234 90379278290928',
              obscure: false,
              controller: _phoneController,
            ),
            const RegTitle(title: 'Password'),
            TextFieldWidget(
              suffix: Icon(Icons.visibility_off),
              hint: '. . . . . . . .',
              obscure: true,
              controller: _passwordController,
            ),
            const SizedBox(
              height: 30,
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
                                        Color.fromRGBO(54, 109, 233, 1),
                                    rightDotColor: Colors.white,
                                    size: 30),
                              );
                            },
                          );
                          // Call the signUp function
                          await _signUp();

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
                        'Continue',
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
            Align(
              alignment: Alignment.center,
              child: const Text(
                'or',
                style: TextStyle(
                    color: Color.fromRGBO(231, 232, 239, 1), fontSize: 14),
              ),
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
                          'Sign up with Google',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    )),
              ),
            ),
            SizedBox(
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
                          'Sign up with Apple',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(
                    color: Color.fromRGBO(151, 151, 151, 1),
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Login',
                      style: TextStyle(
                        color: Color.fromRGBO(16, 47, 84, 1),
                        fontSize: 16,
                      ),
                      // Add your registration logic here
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainLoginScreen()));
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
