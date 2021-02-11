import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker/stores/identifiable.dart';
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/stores/workout_day/workout_day.dart';

part "workout_routine.g.dart";

@jsonSerializable
class WorkoutRoutine extends _WorkoutRoutine with _$WorkoutRoutine {
  WorkoutRoutine();

  WorkoutRoutine.create(
      String name, List<WorkoutDay> workouts, DateTime startDate) {
    id = Uuid().v1();
    this.name = name;
    rawWorkoutDays = [];
    _workouts = ObservableList.of(workouts);
    this.startDate = startDate;
  }
}

abstract class _WorkoutRoutine with Store implements Identifiable {
  @observable
  String id;

  @observable
  String name;

  @observable
  DateTime startDate;

  @observable
  List<String> rawWorkoutDays;

  @observable
  ObservableList<WorkoutDay> _workouts;

  ObservableList<WorkoutDay> get workouts {
    return _workouts;
  }

  void setWorkouts(ObservableList<WorkoutDay> val) {
    _workouts = val;
  }
}
