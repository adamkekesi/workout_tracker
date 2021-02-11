import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String screenTitle;

  const AppTitle({Key key, this.screenTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "EDZÉS SEGÉD",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Arial",
              fontWeight: FontWeight.w800,
              fontSize: 25),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(screenTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Arial",
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
        )
      ],
    );
  }
}
