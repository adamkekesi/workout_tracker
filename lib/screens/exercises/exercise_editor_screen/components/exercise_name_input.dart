import 'package:flutter/material.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/widgets/inputs/styled_text_input.dart';

class ExerciseNameInput extends StatelessWidget {
  final TextEditingController controller;
  final PreferenceStore preferences;
  final Exercise initial;

  ExerciseNameInput(
      {Key key,
      @required this.controller,
      @required this.preferences,
      @required this.initial})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledTextInput(
      decoration: InputDecoration(labelText: "Gyakorlat neve"),
      controller: controller,
      validator: (name) {
        if (name.isEmpty) {
          return "Nem adtad meg a gyakorlat nevét.";
        }
        var exercises = preferences.exercises;
        if (exercises.values
            .any((element) => element.name == name && element != initial)) {
          return "Már van gyakorlatod ilyen névvel.";
        }
        return null;
      },
    );
  }
}
