import 'package:flutter/material.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout_routine/workout_routine.dart';
import 'package:workout_tracker/widgets/inputs/styled_text_input.dart';

class WorkoutRoutineNameInput extends StatelessWidget {
  final TextEditingController controller;
  final PreferenceStore preferences;
  final WorkoutRoutine initial;

  const WorkoutRoutineNameInput(
      {Key key,
      @required this.controller,
      @required this.initial,
      @required this.preferences})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledTextInput(
      decoration: InputDecoration(labelText: "Edzésterv neve"),
      controller: controller,
      validator: (name) {
        if (name.isEmpty) {
          return "Nem adtad meg az edzésterv nevét.";
        }
        var workoutRoutines = preferences.workoutRoutines;
        if (workoutRoutines.values
            .any((element) => element.name == name && element != initial)) {
          return "Már van edzésterved ilyen névvel.";
        }
        return null;
      },
    );
  }
}
