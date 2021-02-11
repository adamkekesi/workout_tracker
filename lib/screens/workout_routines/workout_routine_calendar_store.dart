import 'package:mobx/mobx.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/stores/workout_routine/workout_routine.dart';

part 'workout_routine_calendar_store.g.dart';

class WorkoutRoutineCalendarStore extends _WorkoutRoutineCalendarStore
    with _$WorkoutRoutineCalendarStore {}

abstract class _WorkoutRoutineCalendarStore with Store {
  @observable
  ObservableMap<DateTime, ObservableList<Workout>> workouts =
      ObservableMap.of(Map());

  @observable
  ObservableList<DateTime> visibleDays = ObservableList.of(List(2));

  @observable
  DateTime selectedDate;

  set firstVisible(DateTime val) {
    if (val != null) {
      val = DateTime.utc(val.year, val.month, val.day);
    }
    visibleDays[0] = val;
  }

  set lastVisible(DateTime val) {
    if (val != null) {
      val = DateTime.utc(val.year, val.month, val.day);
    }
    visibleDays[1] = val;
  }

  @computed
  DateTime get firstVisible {
    return visibleDays[0];
  }

  @computed
  DateTime get lastVisible {
    return visibleDays[1];
  }

  @computed
  Workout get selectedWorkout {
    if (selectedDate == null) {
      return null;
    }
    return workouts[selectedDate]?.first;
  }

  ReactionDisposer _activeWorkoutRoutineDisposer;

  ReactionDisposer _visibleDaysDisposer;

  PreferenceStore _preferences = getStore();

  @action
  void _updateWorkouts() {
    this.workouts.clear();
    if ([firstVisible, lastVisible, _preferences.activeWorkoutRoutine]
        .contains(null)) {
      return;
    }
    Map<DateTime, ObservableList<Workout>> workouts = Map();

    DateTime currentDate = firstVisible;
    while (currentDate.compareTo(lastVisible) <= 0) {
      var difference = currentDate
          .difference(_preferences.activeWorkoutRoutine.startDate)
          .abs();
      int index =
          difference.inDays % _preferences.activeWorkoutRoutine.workouts.length;
      var workoutDay = _preferences.activeWorkoutRoutine.workouts[index];
      if (!workoutDay.isRestDay) {
        workouts.addEntries([
          MapEntry(currentDate, ObservableList.of([workoutDay.workout]))
        ]);
      }
      if (index == _preferences.activeWorkoutRoutine.workouts.length - 1) {
        index = 0;
      } else {
        index++;
      }

      currentDate = currentDate.add(Duration(days: 1));
    }
    this.workouts.addAll(workouts);
  }

  @action
  void updateVisibleDates(DateTime first, DateTime last) {
    if (first != firstVisible) {
      firstVisible = first;
    }
    if (last != lastVisible) {
      lastVisible = last;
    }
  }

  @action
  void updateSelectedDate(DateTime date) {
    if (date == null) {
      selectedDate = null;
      return;
    }
    selectedDate = DateTime.utc(date.year, date.month, date.day);
  }

  void dispose() {
    if (_activeWorkoutRoutineDisposer != null) {
      _activeWorkoutRoutineDisposer();
      _visibleDaysDisposer();
    }
  }

  void init() {
    _activeWorkoutRoutineDisposer = autorun((_) {
      if (_preferences.activeWorkoutRoutine != null) {
        _preferences.activeWorkoutRoutine.workouts;
        _updateWorkouts();
      }
    });
    _visibleDaysDisposer = autorun((_) {
      visibleDays.length;
      _updateWorkouts();
    });
    var now = DateTime.now();
    selectedDate = DateTime.utc(now.year, now.month, now.day);
  }
}
