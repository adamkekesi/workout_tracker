import 'package:flutter/material.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/workout/workout.dart';

class WorkoutDisplay extends StatelessWidget {
  final Workout workout;
  final void Function() onTap;
  final Widget trailing;

  const WorkoutDisplay(
      {Key key, @required this.workout, @required this.onTap, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        workout.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
