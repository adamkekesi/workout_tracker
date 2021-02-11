import 'package:flutter/material.dart';
import 'package:workout_tracker/widgets/inputs/date_picker_input/date_picker_input.dart';
import 'package:workout_tracker/widgets/submit_button.dart';

class DatePickerModalContent extends StatelessWidget {
  DatePickerModalContent({Key key}) : super(key: key);

  final _modalHeightPercent = 0.4;

  final _datePickerKey = GlobalKey<FormFieldState<DateTime>>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _modalHeightPercent * MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          DatePickerInput(
            key: _datePickerKey,
            validator: (value) {
              if (value == null) {
                return "Nem választottál dátumot.";
              }
              return null;
            },
            title: Text("Edzés időpontja"),
          ),
          SubmitButton(
            title: "Tovább",
            onSubmit: () => _close(context),
          )
        ],
      ),
    );
  }

  void _close(BuildContext context) {
    if (_datePickerKey.currentState.validate()) {
      Navigator.pop(context, _datePickerKey.currentState.value);
    }
  }
}
