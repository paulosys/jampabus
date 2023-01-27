import 'package:flutter/material.dart';

class DragIndicator extends StatelessWidget {
  const DragIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 3,
        width: 50,
        color: Colors.grey,
        margin: const EdgeInsets.symmetric(vertical: 16.0));
  }
}
