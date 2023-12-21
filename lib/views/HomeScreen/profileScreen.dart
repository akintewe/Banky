import 'dart:convert';

import 'package:banky/views/HomeScreen/editProfileScreen.dart';
import 'package:banky/views/HomeScreen/widgets/profileWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../services/helpers/storeToken.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String firstName = '';
  late String lastName = '';
  late String email = '';
  late String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    // Replace 'YOUR_BEARER_TOKEN' with the actual bearer token
    final bearerToken = UserTokenManager.token;

    final Uri apiUrl = Uri.parse('https://api.banky.ca/v1/user/profile');

    try {
      final http.Response response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'x-api-key':
              '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final Map<String, dynamic> user = jsonResponse['user'];

        setState(() {
          firstName = user['firstName'];
          lastName = user['lastName'];
          email = user['email'];
          phoneNumber = user['phoneNumber'];
        });
      } else {
        // Handle error cases
        print(
            'Failed to fetch user profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network-related errors
      print('Error while fetching user profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hello, $firstName!',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => EditProfileScreen()));
                      //   },
                      //   child: Text(
                      //     'Edit profile',
                      //     style: TextStyle(
                      //         fontSize: 11,
                      //         fontWeight: FontWeight.w600,
                      //         color: Color.fromRGBO(16, 47, 84, 1)),
                      //   ),
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        child: Image.asset('assets/images/male_avatar.png'))),
                ProfileWidget(
                  title: 'Name',
                  image:
                      'assets/icons/4092564_profile_about_mobile ui_user_icon.png',
                  // name gottem from credentials
                  subtitle: '$firstName $lastName',
                  suffix: 'Edit profile',

                  onTap: () {},
                ),
                ProfileWidget(
                  title: 'Email',
                  image:
                      'assets/icons/2674096_object_email_web_essential_icon.png',
                  // mail gotten from credentials
                  subtitle: email,
                  onTap: () {},
                ),
                ProfileWidget(
                  title: 'Mobile Number',
                  image: 'assets/icons/8666632_phone_icon.png',
                  // number gotten from credentials
                  subtitle: phoneNumber,
                  onTap: () {},
                ),
                ProfileWidget(
                  title: 'Change passcode',
                  image:
                      'assets/icons/9104185_padlock_secure_security_protection_passcode_icon.png',
                  onTap: () {},
                ),
                ProfileWidget(
                  title: 'Help',
                  image: 'assets/icons/211757_help_icon.png',
                  onTap: () {},
                ),
                ProfileWidget(
                  title: 'Payment methods',
                  image:
                      'assets/icons/290143_cash_money_payment_wallet_icon.png',
                  onTap: () {},
                ),
                ProfileWidget(
                  title: 'Sign out',
                  image:
                      'assets/icons/4280468_log_out_outlined_logout_sign out_icon.png',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
