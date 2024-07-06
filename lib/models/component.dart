
import 'package:flutter/material.dart';

class EmptyElement extends StatelessWidget {

  final String message;

  const EmptyElement({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: const TextStyle(fontSize: 25, color: Color(0xFF898989))));
  }
}

class HrBox extends StatelessWidget {
  const HrBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 25,
      decoration: BoxDecoration(
        color: Color(0xFFF1F1F5),
      ),
    );
  }
}
