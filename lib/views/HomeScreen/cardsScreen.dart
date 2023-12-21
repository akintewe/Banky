import 'dart:convert';
import 'package:banky/services/helpers/storeToken.dart';
import 'package:banky/views/HomeScreen/paymentSuccessScreen.dart';
import 'package:custom_pin_keyboard/custom_pin_keyboard.dart';
import 'package:http/http.dart' as http;

import 'package:banky/views/HomeScreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:u_credit_card/u_credit_card.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final TextEditingController _paymentNameController = TextEditingController();
  final TextEditingController _customersNameController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  List<String> addedItems = [];
  bool isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101), // You can adjust the last date as needed
    );

    if (picked != null && picked != DateTime.now()) {
      // User has selected a date
      setState(() {
        _dueDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _createPaymentLink() async {
    setState(() {
      isLoading = true;
    });
   try {
  final apiUrl = 'https://api.banky.ca/v1/payment/request/create';
  final String userPin = pinController.text;
  final token = UserTokenManager.token;

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $token',
      'x-api-key':
          '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'customers': addedItems,
      'duedate': _dueDateController.text,
      'amount': double.parse(_amountController.text),
      'passcode': userPin,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData['status'] == true) {
      String paymentLink =
          responseData['paymentResult']['payment']['paymentLink'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PaymentSuccessScreen(paymentLink: paymentLink),
        ),
      );

      // TODO: Send the link to the added customers' emails
      // You can use a service like Firebase Cloud Functions or your own server
    } else {
      // Handle API error
      print('Error: ${responseData['message']}');
    }
  } else if (response.statusCode == 500) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    // Check if the response contains the expected error information
    if (responseData.containsKey('status') &&
        responseData['status'] == false &&
        responseData.containsKey('error')) {
      // Handle the specific error case
      print('Error: ${responseData['error']}');
    } else {
      // Handle other cases where the response structure is not as expected
      print('Invalid response structure for 500 error');
    }
  } else {
    // Handle other HTTP status codes
    print('HTTP Error: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
} catch (e) {
  // Handle other errors
  print('Error: $e');
} finally {
  setState(() {
    isLoading = false;
  });
}

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
                    await _createPaymentLink();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Create payment link',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment link name:',
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
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(16, 47, 84, 1)),
                        child: Center(
                            child: Image.asset(
                          'assets/icons/4092564_profile_about_mobile ui_user_icon.png',
                          color: Colors.white,
                          height: 20,
                        )),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _paymentNameController,

                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'e.g Payment for flowers',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),

                        // Other properties and handlers as needed
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
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
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(16, 47, 84, 1)),
                        child: Center(
                            child: Text(
                          '\$',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        )),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'e.g \$500',
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Due date:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
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
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(16, 47, 84, 1)),
                            child: Center(
                                child: Image.asset(
                              'assets/icons/216119_calender_icon.png',
                              color: Colors.white,
                              height: 20,
                            )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: TextField(
                            onTap: () => _selectDate(context),
                            controller: _dueDateController,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'e.g 05/12/2024',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),

                            // Other properties and handlers as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add customers:',
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
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(16, 47, 84, 1),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/3209291_contacts_customers_family_group_team_icon.png',
                            color: Colors.white,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _customersNameController,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              addedItems.add(value);
                              _customersNameController.clear();
                            });
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'e.g example@gmail.com',
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: addedItems.isNotEmpty
                              ? Container(
                                  width: 130,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: addedItems.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(16, 47, 84, 1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                addedItems[index],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    addedItems.removeAt(index);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
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
                        child: isLoading
                            ? LoadingAnimationWidget.flickr(
                                leftDotColor: Color.fromRGBO(54, 109, 233, 1),
                                rightDotColor: Colors.white,
                                size: 30)
                            : Text(
                                'Create payment link',
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
      ),
    );
  }
}
