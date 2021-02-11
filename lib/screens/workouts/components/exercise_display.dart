import 'package:flutter/material.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';

class ExerciseDisplay extends StatelessWidget {
  final Exercise exercise;
  final void Function() onTap;
  final Widget trailing;

  const ExerciseDisplay(
      {Key key, @required this.exercise, @required this.onTap, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        exercise.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${exercise.idealSets} sorozat"),
          Text("${exercise.idealRepsLow} - ${exercise.idealRepsHigh} ismétlés")
        ],
      ),
      trailing: trailing,
    );
  }
}
