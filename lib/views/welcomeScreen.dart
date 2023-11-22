import 'package:banky/views/loginScreen.dart';
import 'package:banky/views/mainLoginScreen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(16, 47, 84, 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(130),
                      bottomRight: Radius.circular(130)),
                ),
              )),
          Positioned(
            top: 325,
            left: 130,
            child: CircleAvatar(
              backgroundColor: const Color.fromRGBO(244, 245, 248, 1),
              child: Center(
                child: Image.asset(
                  'assets/images/logo-no-background.png',
                  height: 30,
                ),
              ),
              radius: 70,
            ),
          ),
          Positioned(
              bottom: 350,
              left: MediaQuery.of(context).size.width * 0.19,
              child: const Text(
                'A platform for a new way of working',
                style: TextStyle(color: Colors.black, fontSize: 15),
              )),
          Positioned(
              bottom: 330,
              left: MediaQuery.of(context).size.width * 0.25,
              child: const Text(
                'and easy banking experience',
                style: TextStyle(color: Colors.black, fontSize: 15),
              )),
          Positioned(
              bottom: 200,
              left: MediaQuery.of(context).size.width * 0.25,
              child: SizedBox(
                height: 50,
                width: 210,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(16, 47, 84, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainLoginScreen()));
                    },
                    child: const Row(
                      children: [
                        Text(
                          'Get Started for Free',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 9,
                        )
                      ],
                    )),
              )),
        ],
      ),
    );
  }
}
