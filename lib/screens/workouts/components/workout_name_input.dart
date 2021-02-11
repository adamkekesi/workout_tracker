import 'package:flutter/material.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/widgets/inputs/styled_text_input.dart';

class WorkoutNameInput extends StatelessWidget {
  final TextEditingController controller;
  final PreferenceStore preferences;
  final Workout initial;

  const WorkoutNameInput(
      {Key key,
      @required this.controller,
      @required this.preferences,
      @required this.initial})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledTextInput(
      decoration: InputDecoration(labelText: "Edzés neve"),
      controller: controller,
      validator: (name) {
        if (name.isEmpty) {
          return "Nem adtad meg az edzés nevét.";
        }
        var workouts = preferences.workouts;
        if (workouts.values
            .any((element) => element.name == name && element != initial)) {
          return "Már van edzésed ilyen névvel.";
        }
        return null;
      },
    );
  }
}
