import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ProfileWidget extends StatefulWidget {
  final String title;
  final String image;
  final String? suffix;
  final String? subtitle;
  final bool toggle;
  final VoidCallback? onTap;
  const ProfileWidget({
    Key? key,
    required this.title,
    required this.image,
    this.suffix,
    this.subtitle = '',
    this.onTap,
    this.toggle = false,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                    height: 20,
                    child: Image.asset(
                      widget.image,
                      color: Color.fromRGBO(16, 47, 84, 1),
                    )),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18),
                    Text(widget.title,
                        style: TextStyle(
                            color: Color.fromRGBO(16, 47, 84, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    Text(
                      widget.subtitle.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    )
                  ],
                ),
              ],
            ),
            widget.toggle
                ? FlutterSwitch(
                    activeColor: Color.fromRGBO(16, 47, 84, 1),
                    inactiveColor: Colors.grey,
                    width: 40.0,
                    height: 20.0,
                    toggleSize: 16.0,
                    padding: 2.0,
                    value: status,
                    borderRadius: 10.0,
                    onToggle: (val) {
                      setState(() {
                        status = val;
                      });
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
