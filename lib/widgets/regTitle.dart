import 'package:flutter/material.dart';

class RegTitle extends StatefulWidget {
  final String title;
  const RegTitle({
    super.key,
    required this.title,
  });

  @override
  State<RegTitle> createState() => _RegTitleState();
}

class _RegTitleState extends State<RegTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 10, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
