import 'package:flutter/material.dart';
import 'package:workout_tracker/config/colors.dart';

class SubmitButton extends StatelessWidget {
  final void Function() onSubmit;

  final String title;

  const SubmitButton({Key key, this.onSubmit, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: onSubmit,
        color: lightColor,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      ),
      margin: EdgeInsets.only(top: 20),
    );
  }
}
