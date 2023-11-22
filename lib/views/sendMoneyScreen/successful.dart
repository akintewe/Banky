import 'package:banky/views/HomeScreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessfulPage extends StatefulWidget {
  final String name;
  final String amount;
  const SuccessfulPage({super.key, required this.name, required this.amount});

  @override
  State<SuccessfulPage> createState() => _SuccessfulPageState();
}

class _SuccessfulPageState extends State<SuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        SizedBox(
            height: 150, child: Lottie.asset('assets/animations/Success.json')),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Transaction Successful',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'You have made a transfer of \$${widget.amount} to',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            '${widget.name} successfully....',
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
                onPressed: () {},
                child: Center(
                  child: Text(
                    'Share reciept',
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
