import 'package:banky/views/HomeScreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotSuccessful extends StatefulWidget {
  const NotSuccessful({super.key});

  @override
  State<NotSuccessful> createState() => _NotSuccessfulState();
}

class _NotSuccessfulState extends State<NotSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        SizedBox(
            height: 150, child: Lottie.asset('assets/animations/Failed.json')),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Transaction Failed!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'You have insufficient funds in this account',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'please fund your account and try again...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Center(
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )),
          ),
        )
      ],
    ));
  }
}
