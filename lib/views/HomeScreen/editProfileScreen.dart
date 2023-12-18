import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the user's current profile to pre-fill the form
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    // Fetch user profile logic (similar to what you did in ProfileScreen)
  }

  Future<void> _updateUserProfile() async {
    final String bearerToken = 'YOUR_BEARER_TOKEN'; // Replace with actual token

    final Uri apiUrl = Uri.parse('https://api.banky.ca/v1/user/profile/edit');

    final Map<String, String> requestBody = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'phoneNumber': phoneNumberController.text,
    };

    try {
      final http.Response response = await http.put(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'x-api-key':
              '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Handle success response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Profile updated successfully: ${jsonResponse['message']}');
      } else {
        // Handle error cases
        print(
            'Failed to update user profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network-related errors
      print('Error while updating user profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Save changes when the user presses the save button
              _updateUserProfile();
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Wrap your form with Form widget
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextButton(
                onPressed: () {
                  // Save changes when the user presses the save button
                  _updateUserProfile();
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              // Add more fields as needed
            ],
          ),
        ),
      ),
    );
  }
}
