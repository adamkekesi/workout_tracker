import 'package:workout_tracker/stores/progression/progression.dart';
import 'package:workout_tracker/stores/workout/workout.dart';

class ProgressionInputState {
  WorkoutSet workoutSet;

  String weightRaw;

  String repsRaw;

  ProgressionInputState(WorkoutSet workoutSet) {
    this.workoutSet = workoutSet;
    weightRaw = workoutSet.weight == null ? "" : workoutSet.weight.toString();
    repsRaw = workoutSet.reps == null ? "" : workoutSet.reps.toString();
  }

  void updateReps(String value) {
    repsRaw = value;
    int reps = value == null ? null : int.tryParse(value);
    workoutSet.reps = reps;
  }

  void updateWeight(String value) {
    weightRaw = value;
    double weight = value == null ? null : double.tryParse(value);
    workoutSet.weight = weight;
  }
}
