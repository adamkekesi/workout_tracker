import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workout_tracker/screens/progression/components/progression_input/progression_input_state.dart';
import 'package:workout_tracker/stores/progression/progression.dart';
import 'package:workout_tracker/widgets/inputs/styled_text_input.dart';

class ProgressionInput extends FormField<ProgressionInputState> {
  ProgressionInput(
      {Key key,
      FormFieldSetter<ProgressionInputState> onSaved,
      void Function() onDelete,
      FormFieldValidator<ProgressionInputState> validator,
      WorkoutSet initialValue,
      bool showDeleteButton = true})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: ProgressionInputState(
                initialValue ?? WorkoutSet.create(null, null)),
            autovalidate: true,
            builder: (FormFieldState<ProgressionInputState> state) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 12, right: 24),
                      child: StyledTextInput(
                        initialValue: state.value.repsRaw,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        autovalidate: true,
                        decoration: InputDecoration(
                          labelText: "Ismétlés",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          int parsed = int.tryParse(value);
                          if (parsed == null || parsed <= 0) {
                            return "Helytelen számot adtál meg.";
                          }
                          return null;
                        },
                        onChanged: (value) =>
                            state.didChange(state.value..updateReps(value)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 24, right: 12),
                      alignment: Alignment.center,
                      child: StyledTextInput(
                        initialValue: state.value.weightRaw,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        autovalidate: true,
                        decoration: InputDecoration(
                          labelText: "Súly",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          double parsed = double.tryParse(value);
                          if (parsed == null || parsed <= 0) {
                            return "Helytelen számot adtál meg.";
                          }
                          return null;
                        },
                        onChanged: (value) =>
                            state.didChange(state.value..updateWeight(value)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (showDeleteButton) {
                        onDelete();
                      }
                    },
                    child: Opacity(
                        opacity: showDeleteButton ? 1 : 0,
                        child: Icon(Icons.close)),
                  )
                ],
              );
            });
}
