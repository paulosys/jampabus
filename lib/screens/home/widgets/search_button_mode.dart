import 'package:flutter/material.dart';

class SearchButtonMode extends StatelessWidget {
  final Text label;
  final Icon icon;
  final Function onTap;
  const SearchButtonMode(
      {super.key, required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(70, 56),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(),
            splashColor: Colors.blueGrey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon, // <-- Icon
                label, // <-- Text
              ],
            ),
          ),
        ),
      ),
    );
  }
}