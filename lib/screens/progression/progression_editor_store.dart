import 'package:mobx/mobx.dart';
import 'package:workout_tracker/stores/progression/progression.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';

part 'progression_editor_store.g.dart';

class ProgressionEditorStore extends _ProgressionEditorStore
    with _$ProgressionEditorStore {
  ProgressionEditorStore(
      DateTime date, Progression progression, Exercise exercise) {
    this.date = date;
    this.sets = ObservableList.of([
      ...progression.sets
          .map((element) => WorkoutSet.create(element.weight, element.reps)),
      WorkoutSet.create(null, null)
    ]);
    this.initial = progression;
    this.exercise = exercise;
  }
}

abstract class _ProgressionEditorStore with Store {
  @observable
  DateTime date;

  @observable
  ObservableList<WorkoutSet> sets;

  @observable
  Exercise exercise;

  @observable
  Progression initial;

  ReactionDisposer _setsReactionDisposer;

  void init() {
    _setsReactionDisposer = autorun((_) {
      var last = sets[sets.length - 1];
      if (last != null && last.isInitialized) {
        sets.add(WorkoutSet.create(null, null));
      }
      var initializedSets = sets.where((element) => element.isInitialized);
      if (initializedSets.length > 0) {
        exercise.getProgression()[date] =
            Progression.create(initializedSets.toList(), date);
      } else {
        exercise.getProgression().remove(date);
      }
    });
  }

  @action
  void reset() {
    exercise.getProgression()[date] = initial;
    sets = ObservableList.of([
      ...initial.sets
          .map((element) => WorkoutSet.create(element.weight, element.reps)),
      WorkoutSet.create(null, null)
    ]);
  }

  @action
  void delete() {
    exercise.getProgression().remove(date);
    sets = ObservableList.of([WorkoutSet.create(null, null)]);
  }

  void dispose() {
    _setsReactionDisposer();
  }
}
