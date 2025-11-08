import 'package:flutter/material.dart';

class ChooseLocation extends StatelessWidget {
  const ChooseLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '📍 Choose Location Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
