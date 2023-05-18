import 'package:flutter/material.dart';
import 'page.dart';

class CalculatePage extends PageWidget {
  const CalculatePage({
    Key? key,
  }) : super(key: key, title: "Calculate");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Text(title),
        ),
      ],
    );
  }
}
