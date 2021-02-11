import 'package:flutter/material.dart';
import 'package:workout_tracker/widgets/inputs/styled_text_input.dart';

class SetsInput extends StatelessWidget {
  final TextEditingController controller;

  const SetsInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledTextInput(
      decoration: InputDecoration(labelText: "Sorozat"),
      keyboardType: TextInputType.number,
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return "Nem adtad meg a sorozatokat.";
        }
        int parsed = int.tryParse(value);
        if (parsed == null) {
          return "Nem egy egész számot adtál meg.";
        }
        if (parsed < 1) {
          return "A sorozatnak 0-nál nagyobbnak kell lennie.";
        }
        return null;
      },
    );
  }
}
