import 'package:flutter/material.dart';
import 'package:workout_tracker/config/colors.dart';

class ListSeparator extends StatelessWidget {
  const ListSeparator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 11),
      child: Divider(
        color: redColor,
        thickness: 1,
      ),
    );
  }
}
