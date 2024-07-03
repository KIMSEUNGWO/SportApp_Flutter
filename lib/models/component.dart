
import 'package:flutter/material.dart';

class EmptyElement extends StatelessWidget {

  final String message;

  const EmptyElement({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: const TextStyle(fontSize: 25, color: Color(0xFF898989))));
  }
}