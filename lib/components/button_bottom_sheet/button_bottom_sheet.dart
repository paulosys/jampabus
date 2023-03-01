import 'package:flutter/material.dart';

class ButtonBottomAppBar extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Function onTap;
  const ButtonBottomAppBar(
      {Key? key,
      required this.label,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
        height: 46,
        width: 64,
        child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            onTap: () => onTap(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(iconData),
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            )));
  }
}
