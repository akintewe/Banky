import 'dart:convert';
import 'package:banky/services/helpers/storeToken.dart';
import 'package:http/http.dart' as http;
import 'package:banky/views/sendMoneyScreen/enterAmount.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final TextEditingController _recipientController = TextEditingController();

  bool _isButtonEnabled = false;

  Future<void> requestContactsPermission() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      await Permission.contacts.request();
    }
  }

  @override
  void initState() {
    _recipientController.addListener(_checkButton);
    // TODO: implement initState
    super.initState();
  }

  void _checkButton() {
    final recipient = _recipientController.text;

    setState(() {
      _isButtonEnabled = recipient.isNotEmpty;
    });
  }

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
          'Send Money',
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
                  'Enter the recipient\'s email or phone number',
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
                      '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _recipientController,

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email or phone number',
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
              height: 15,
            ),
            Align(
              alignment: Alignment.center,
              child: Text('or'),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () => _openContactsPage(context),
                child: Text(
                  'Choose from Contacts',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color.fromRGBO(16, 47, 84, 1)),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350,
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
                            await _getUserDetails(_recipientController.text);
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
                          'Next',
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getUserDetails(String recipient) async {
    print('Request started');
    final apiUrl =
        'https://api.banky.ca/v1/payment/wallet/transfer/single/details';
    final token = UserTokenManager.token;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key':
              '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'recipient': _recipientController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Gotten user info');

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('status') && responseBody['status']) {
          final Map<String, dynamic> recipientConfirmation =
              responseBody['recipientConfirmation'];
          Navigator.pop(context); // Dismiss the loading dialog
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnterAmount(
                userFirstName: recipientConfirmation['firstName'],
                userLastName: recipientConfirmation['lastName'],
                userPhoneNumber: recipientConfirmation['phoneNumber'],
                userEmail: recipientConfirmation['email'],
              ),
            ),
          );
        } else {
          // Handle error case
          print('Error retrieving user details: ${response.body}');
          _showErrorSnackbar('An unexpected error occurred');
        }
      } else if (response.statusCode == 400) {
        _showErrorSnackbar('Error, You cant send funds to yourself');
      
      } else {
        // Handle other error cases
        print('Error retrieving user details: ${response.statusCode}');
       
      }
    } catch (e) {
      print('Error: $e');
      _showErrorSnackbar('An unexpected error occurred');
    }
  }

  void _showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Future<void> _openContactsPage(BuildContext context) async {
  final status = await Permission.contacts.request();
  if (status.isGranted) {
    final contacts = await ContactsService.getContacts();
    print('Contacts: $contacts');

    // Use the contacts list as needed
  } else {
    print('Permission denied');
  }
}
