import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';

part "progression.g.dart";

@jsonSerializable
class Progression extends _Progression with _$Progression {
  Progression();

  Progression.create(List<WorkoutSet> sets, DateTime date) {
    this.setSets(ObservableList.of(sets));
    this.rawSets = [];
    this.date = date;
  }
}

abstract class _Progression with Store {
  @observable
  DateTime date;

  @observable
  List<String> rawSets;

  @observable
  ObservableList<WorkoutSet> _sets;

  @computed
  int get numSets => sets?.length;

  @computed
  double get highestWeight {
    double max = 0;
    sets?.forEach((element) {
      if (element.weight > max) {
        max = element.weight;
      }
    });
    return max;
  }

  @computed
  int get highWeightSets =>
      (sets?.where((element) => element.weight == highestWeight) ?? []).length;

  ObservableList<WorkoutSet> get sets {
    return _sets;
  }

  void setSets(ObservableList<WorkoutSet> sets) {
    _sets = sets;
  }
}

@jsonSerializable
class WorkoutSet extends _WorkoutSet with _$WorkoutSet {
  WorkoutSet();

  WorkoutSet.create(double weight, int reps) {
    this.weight = weight;
    this.reps = reps;
  }
}

abstract class _WorkoutSet with Store {
  @observable
  double weight;

  @observable
  int reps;

  @computed
  bool get isInitialized => weight != null && reps != null;
}
