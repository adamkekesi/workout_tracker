import 'package:flutter/material.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout/workout.dart';

class ProgressionHistoryScreen extends StatelessWidget {
  final _store = getStore();

  final Workout workout;

  ProgressionHistoryScreen({Key key, @required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        title: Text("Korábbi edzések: ${workout.name}"),
      ),
    );
  }
}
