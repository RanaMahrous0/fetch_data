import 'package:flutter/material.dart';

class Mytitle extends StatelessWidget {
  final String title;
  const Mytitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor),
    );
  }
}
