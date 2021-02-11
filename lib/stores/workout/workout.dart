import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/identifiable.dart';

part "workout.g.dart";

@jsonSerializable
class Workout extends _Workout with _$Workout {
  Workout();

  Workout.create(String name, List<Exercise> exercises) {
    id = Uuid().v1();
    this.name = name;
    exerciseIds = exercises.map((e) => e.id).toList();
    _exercises = ObservableList.of(exercises);
  }
}

abstract class _Workout with Store implements Identifiable {
  @observable
  List<String> exerciseIds;

  @observable
  String id;

  @observable
  String name;

  @observable
  ObservableList<Exercise> _exercises;

  ObservableList<Exercise> get exercises {
    return _exercises;
  }

  void setExercises(ObservableList<Exercise> val) {
    _exercises = val;
  }
}
