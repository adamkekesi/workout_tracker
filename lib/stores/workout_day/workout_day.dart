import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker/stores/identifiable.dart';
import 'package:workout_tracker/stores/workout/workout.dart';

part 'workout_day.g.dart';

@jsonSerializable
class WorkoutDay extends _WorkoutDay with _$WorkoutDay {
  WorkoutDay();

  WorkoutDay.restDay() {
    id = Uuid().v1();
    _workout = null;
    isRestDay = true;
  }

  WorkoutDay.workoutDay(Workout workout) {
    id = Uuid().v1();
    this._workout = workout;
    this.workoutId = workout.id;
    isRestDay = false;
  }
}

abstract class _WorkoutDay with Store implements Identifiable {
  @observable
  String id;

  @observable
  String workoutId;

  @observable
  Workout _workout;

  Workout get workout {
    return _workout;
  }

  void setWorkout(Workout workout) {
    _workout = workout;
  }

  @observable
  bool isRestDay;
}
