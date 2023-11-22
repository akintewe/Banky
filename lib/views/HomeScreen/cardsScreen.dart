import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final List<Map<String, dynamic>> itemList = [
    {
      'name': 'Bolt',
      'time': 'Debit Card, 07 May, 2023',
      'amount': '-\$34.00',
      'image': 'assets/images/bolt.png',
      'amountColor': Colors.red, // Path to Alice's image
    },
    {
      'name': 'Joseph',
      'time': 'Transfer, 10 May, 2023',
      'amount': '-\$650.00',
      'image': 'assets/images/image2.png',
      'amountColor': Colors.red, // Path to Bob's image
    },
    {
      'name': 'Mark',
      'time': 'Credit, 15 May, 2023',
      'amount': '+\$1000.00',
      'image': 'assets/images/image4.png',
      'amountColor': Colors.green, // Path to Bob's image
    },
    {
      'name': 'KFC Resturant',
      'time': 'Debit Card, 23 June, 2023',
      'amount': '-\$200.00',
      'image': 'assets/images/kfc.png',
      'amountColor': Colors.red, // Path to Bob's image
    },
    {
      'name': 'Uncle Jonathan',
      'time': 'Credit, 25 June, 2023',
      'amount': '+\$150.00',
      'image': 'assets/images/image3.png',
      'amountColor': Colors.green, // Path to Bob's image
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(54, 109, 233, 1)),
            child: const Center(
              child: Icon(
                Icons.sort,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: const Text(
          'My Cards',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CreditCardUi(
                      topLeftColor: Colors.blue,
                      cardHolderFullName: 'Nathan Akin',
                      cardNumber: '\$23,456.08',
                      validFrom: '01/23',
                      validThru: '10/24',
                      cardType: CardType.debit,
                      doesSupportNfc: true,
                      placeNfcIconAtTheEnd: true,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CreditCardUi(
                      topLeftColor: Colors.pink,
                      cardHolderFullName: 'Nathan Akin',
                      cardNumber: '\$23,456.08',
                      validFrom: '05/23',
                      validThru: '09/24',
                      cardType: CardType.credit,
                      doesSupportNfc: true,
                      placeNfcIconAtTheEnd: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.98,
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
                          backgroundImage: AssetImage(item['image']),
                        ),
                        title: Text(
                          item['name'],
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(item['time']),
                        trailing: Text(
                          item['amount'],
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
          ],
        ),
      ),
    );
  }
}
