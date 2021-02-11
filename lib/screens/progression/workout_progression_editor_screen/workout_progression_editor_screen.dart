import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/progression/components/progression_editor_card.dart';
import 'package:workout_tracker/stores/progression/progression.dart';
import 'package:workout_tracker/stores/workout/workout.dart';

class WorkoutProgressionEditorScreen extends StatelessWidget {
  final Workout workout;

  final DateTime date;

  WorkoutProgressionEditorScreen(
      {Key key, @required this.workout, @required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Fejlődés:",
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 6),
              alignment: Alignment.bottomLeft,
              child: Text(
                workout.name,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
        backgroundColor: redColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...workout.exercises.map((exercise) => Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ProgressionEditorCard(
                  exercise: exercise,
                  date: date,
                  progression: exercise.getProgression()[date] ??
                      Progression.create([], date),
                )))
          ],
        ),
      ),
    );
  }
}
