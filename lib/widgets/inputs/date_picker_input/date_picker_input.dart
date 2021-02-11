import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/config/colors.dart';

class DatePickerInput extends FormField<DateTime> {
  DatePickerInput(
      {Key key,
      FormFieldSetter<DateTime> onSaved,
      FormFieldValidator<DateTime> validator,
      @required Widget title,
      DateTime initialValue,
      bool autovalidate = false})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<DateTime> state) {
              DateFormat format = DateFormat("yyyy. MM. dd.", "hu");

              String pickerValue = state.value == null
                  ? "Válassz egy dátumot"
                  : format.format(state.value);
              return Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: title,
                  ),
                  InkWell(
                    onTap: () async {
                      DateTime now = DateTime.now();
                      DateTime lastDate =
                          DateTime(now.year + 1, now.month, now.day);
                      DateTime today = DateTime(now.year, now.month, now.day);
                      DateTime result = await showDatePicker(
                          context: state.context,
                          initialDate:
                              state.value == null ? today : state.value,
                          locale: Locale("hu", "HU"),
                          firstDate: DateTime(1970),
                          lastDate: lastDate);
                      state.didChange(result);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: redColor, width: 0.6),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      child: Text(pickerValue),
                    ),
                  ),
                  if (state.errorText != null)
                    Text(
                      state.errorText,
                      style: TextStyle(color: Colors.red),
                    )
                ],
              );
            });
}
