import 'dart:collection';
import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker/stores/identifiable.dart';
import 'package:workout_tracker/stores/progression/progression.dart';

part 'exercise.g.dart';

@jsonSerializable
class Exercise extends _Exercise with _$Exercise {
  Exercise();

  Exercise.create(
      String name, int idealSets, int idealRepsLow, int idealRepsHigh) {
    id = Uuid().v1();
    this.name = name;
    this.idealRepsLow = idealRepsLow;
    this.idealRepsHigh = idealRepsHigh;
    this.idealSets = idealSets;
    _progression = ObservableMap.of({});
    progressionRaw = [];
  }
}

@jsonSerializable
abstract class _Exercise with Store implements Identifiable {
  @observable
  String id;

  @observable
  String name;

  @observable
  ObservableMap<DateTime, Progression> _progression;

  ObservableMap<DateTime, Progression> getProgression() {
    return _progression;
  }

  void setProgression(ObservableMap<DateTime, Progression> val) {
    _progression = val;
  }

  @observable
  List<String> progressionRaw;

  @observable
  int idealRepsLow;

  @observable
  int idealRepsHigh;

  @observable
  int idealSets;

  _Exercise();

  @computed
  Progression get latestProgression {
    var entries = _progression?.entries ?? [];
    if (entries.length == 0) {
      return null;
    }
    var sorted = entries.toList()
      ..sort((a, b) => Comparable.compare(b.key, a.key));
    return sorted[0].value;
  }

  @computed
  double get highestWeight {
    double max = 0;
    if (_progression == null) {
      return max;
    }
    _progression.values.forEach((element) {
      var highestWeight = element.highestWeight;
      if (highestWeight > max) {
        max = highestWeight;
      }
    });
    return max;
  }
}
