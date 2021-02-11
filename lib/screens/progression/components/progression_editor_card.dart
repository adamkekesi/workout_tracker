import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/progression/components/progression_input/progression_input.dart';
import 'package:workout_tracker/screens/progression/components/progression_input/progression_input_state.dart';
import 'package:workout_tracker/screens/progression/progression_editor_store.dart';
import 'package:workout_tracker/screens/workouts/components/exercise_display.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/progression/progression.dart';
import 'package:workout_tracker/widgets/inputs/styled_text_input.dart';

class ProgressionEditorCard extends StatefulWidget {
  final Exercise exercise;

  final DateTime date;

  final Progression progression;

  ProgressionEditorCard(
      {Key key,
      @required this.exercise,
      @required this.date,
      @required this.progression})
      : super(key: key);

  @override
  _ProgressionEditorCardState createState() => _ProgressionEditorCardState();
}

class _ProgressionEditorCardState extends State<ProgressionEditorCard> {
  ProgressionEditorStore _store;

  @override
  void initState() {
    super.initState();
    _store =
        ProgressionEditorStore(widget.date, widget.progression, widget.exercise)
          ..init();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Container(
        child: Card(
          child: Column(
            children: [
              ExerciseDisplay(exercise: _store.exercise, onTap: null),
              Divider(
                thickness: 1,
              ),
              ..._store.sets.map((element) => ProgressionInput(
                  key: ObjectKey(element),
                  initialValue: element,
                  onDelete: () => _onDeleteSet(element),
                  showDeleteButton: _store.sets.last != element)),
              Padding(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ButtonBar(
                    children: [
                      FlatButton(
                          onPressed: _onReset,
                          child: Text(
                            "Visszaállítás",
                            style: TextStyle(color: brightColor),
                          )),
                      FlatButton(
                          onPressed: _onDeleteProgression,
                          child: Text(
                            "Törlés",
                            style: TextStyle(color: brightColor),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onDeleteSet(
    WorkoutSet workoutSet,
  ) {
    _store.sets.remove(workoutSet);
  }

  void _onDeleteProgression() {
    _store.delete();
  }

  void _onReset() {
    _store.reset();
  }

  @override
  void dispose() {
    super.dispose();
    _store.dispose();
  }
}
