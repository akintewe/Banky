import 'package:banky/services/helpers/storeId.dart';
import 'package:banky/services/helpers/storeToken.dart';
import 'package:banky/services/helpers/storeUsername.dart';
import 'package:banky/views/fundWalletScreen/fundWalletScreen.dart';
import 'package:banky/views/sendMoneyScreen/sendMoney.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final String? userName;
  const HomeScreen({super.key, this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userName = UserNameManager.userName;

  List<Map<String, dynamic>> itemList = [];
  double walletBalance = 0.0;
  @override
  void initState() {
    super.initState();
    _getUserDetails().then((_) {
      _getWalletBalance();
      _fetchTransactionHistory();
    });
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

  Future<void> _getWalletBalance() async {
    final apiUrl = 'https://api.banky.ca/v1/wallet/balance';
    final token = UserTokenManager.token;
    final userId = UserIdManager.id; // Replace with your actual API key

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key':
              '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4',
          'Content-Type': 'application/json',
          '_id': '$userId',
        },
      );

      if (response.statusCode == 200) {
        // Handle success response
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('balance')) {
          setState(() {
            walletBalance = double.parse(responseBody['balance'].toString());
          });
        }
      } else {
        // Handle error response
        print('Error fetching wallet balance: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception occurred: $e');
    }
  }

  // final List<Map<String, dynamic>> itemList = [
  //   {
  //     'name': 'Maria May',
  //     'time': 'Today, 10:00 AM',
  //     'amount': '+\$700.00',
  //     'image': 'assets/images/image1.png',
  //     'amountColor': Colors.green, // Path to Alice's image
  //   },
  //   {
  //     'name': 'Bolt',
  //     'time': 'Debit Card, 07 May, 2023',
  //     'amount': '-\$34.00',
  //     'image': 'assets/images/bolt.png',
  //     'amountColor': Colors.red, // Path to Alice's image
  //   },
  //   {
  //     'name': 'KFC Resturant',
  //     'time': 'Debit Card, 23 June, 2023',
  //     'amount': '-\$200.00',
  //     'image': 'assets/images/kfc.png',
  //     'amountColor': Colors.red, // Path to Bob's image
  //   },
  //   {
  //     'name': 'Uncle Jonathan',
  //     'time': 'Credit, 25 June, 2023',
  //     'amount': '+\$150.00',
  //     'image': 'assets/images/image3.png',
  //     'amountColor': Colors.green, // Path to Bob's image
  //   },
  //   {
  //     'name': 'Peter Frank',
  //     'time': 'Today, 11:30 AM',
  //     'amount': '-\$650.00',
  //     'image': 'assets/images/image2.png',
  //     'amountColor': Colors.red, // Path to Bob's image
  //   },
  // ];
  Future<void> _fetchTransactionHistory() async {
    try {
      final apiUrl =
          'https://api.banky.ca/v1/transaction/history/${UserIdManager.id}';
      final token = UserTokenManager.token;
      final userId = UserIdManager.id;

      print('user Id from here :  ${UserIdManager.id}');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'x-api-key':
              '95c31583b2fdce5990a72d18e6efef5f:9c11c633d2157a0e662e3d879e888d920d6b8f9066f790d042510080f933b4b4',
          '_id': '${UserIdManager.id}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('status') && responseData['status']) {
          final List<dynamic> transactions = responseData['transactions'];

          setState(() {
            itemList = transactions.map((transaction) {
              String senderId = transaction['sender']['_id'];
              String recipientId = transaction['recipient']['_id'];
              bool isSender = senderId == UserIdManager.id;

              return {
                'name': isSender
                    ? transaction['recipient']['firstName']
                    : transaction['sender']['firstName'],
                'time': transaction['createdAt'],
                'amount': transaction['amount'],
                'amountColor': isSender ? Colors.red : Colors.green,
              };
            }).toList();
          });
        } else {
          // Handle API error
          print('Error: ${responseData['message']}');
        }
      } else {
        // Handle other HTTP status codes
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: Container(
                height: 350,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(16, 47, 84, 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 200,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/Avatar.png',
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Hello, ${UserNameManager.userName ?? "Guest"}',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .9,
                      height: 130,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(133, 25, 74, 133),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Balance',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FundWalletScreen()));
                                    },
                                    child: Image.asset(
                                      'assets/icons/Fund.png',
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '\$$walletBalance',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 40),
                                )),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SendMoney()));
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(133, 25, 74, 133),
                                  radius: 30,
                                  child: Image.asset(
                                    'assets/icons/sendmoney.png',
                                    height: 20,
                                  ),
                                ),
                              ),
                              const Text(
                                'Send',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(133, 25, 74, 133),
                                radius: 30,
                                child: Image.asset(
                                  'assets/icons/recievemoney.png',
                                  height: 20,
                                ),
                              ),
                              const Text(
                                'Request',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(133, 25, 74, 133),
                                radius: 30,
                                child: Image.asset(
                                  'assets/icons/withdraw.png',
                                  height: 20,
                                ),
                              ),
                              const Text(
                                'Withdraw',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              top: 380,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Text(
                      'Quick Transfer',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.56,
                    ),
                    const Text(
                      'Edit',
                      style: TextStyle(
                          fontSize: 13, color: Color.fromRGBO(76, 76, 76, 1)),
                    ),
                  ],
                ),
              )),
          Positioned(
              top: 430,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/images/image1.png'),
                            const Text('Anna')
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Image.asset('assets/images/image2.png'),
                            const Text('John')
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Image.asset('assets/images/image3.png'),
                            const Text('Fred')
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Image.asset('assets/images/image4.png'),
                            const Text('Jake.M')
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    Color.fromRGBO(245, 245, 245, 1),
                                child: Icon(Icons.add),
                              ),
                            ),
                            Text('Add')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
              top: 520,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    const Text(
                      'View All',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(76, 76, 76, 1)),
                    ),
                  ],
                ),
              )),
          Positioned(
            top: 570,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .3,
              child: ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (BuildContext context, int index) {
                  // Access data for each item from the itemList
                  var item = itemList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(245, 245, 245, 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          // Load image dynamically from the item data
                          backgroundImage:
                              AssetImage('assets/images/image2.png'),
                        ),
                        title: Text(
                          item['name'],
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(item['time']),
                        trailing: Text(
                          '\$${item['amount'].toString()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: item[
                                'amountColor'], // Apply custom color to the amount text
                          ),
                        ),
                        onTap: () {
                          // Handle item tap
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
