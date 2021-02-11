import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/progression/progression.dart';
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/stores/workout_day/workout_day.dart';
import 'package:workout_tracker/stores/workout_routine/workout_routine.dart';

part "preference-store.g.dart";

PreferenceStore preferenceStore;

PreferenceStore getStore() {
  if (preferenceStore == null) {
    preferenceStore = PreferenceStore();
  }
  return preferenceStore;
}

class PreferenceStore extends _PreferenceStore with _$PreferenceStore {}

abstract class _PreferenceStore with Store {
  @observable
  ObservableMap<String, Exercise> exercises;

  @observable
  ObservableMap<String, Workout> workouts;

  @observable
  ObservableMap<String, WorkoutRoutine> workoutRoutines;

  @observable
  bool loaded = false;

  @observable
  WorkoutRoutine activeWorkoutRoutine;

  ReactionDisposer exerciseObserver;

  ReactionDisposer workoutObserver;

  ReactionDisposer workoutRoutineObserver;

  ReactionDisposer activeWorkoutRoutineObserver;

  _PreferenceStore() {
    exercises = ObservableMap.of({});
    workouts = ObservableMap.of({});
    workoutRoutines = ObservableMap.of({});
  }

  @action
  void deleteExercise(Exercise exercise) {
    exercises.remove(exercise.id);
    workouts.forEach((key, workout) {
      workout.exercises.remove(exercise);
    });
  }

  @action
  void deleteWorkout(Workout workout) {
    workouts.remove(workout.id);
    workoutRoutines.forEach((key, workoutRoutine) {
      workoutRoutine.workouts.removeWhere(
          (element) => !element.isRestDay && element.workout == workout);
    });
  }

  @action
  void deleteWorkoutRoutine(WorkoutRoutine workoutRoutine) {
    workoutRoutines.remove(workoutRoutine.id);
    if (activeWorkoutRoutine == workoutRoutine) {
      activeWorkoutRoutine = null;
    }
  }

  @action
  Future<void> loadFromPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("exercises")) {
      Iterable<MapEntry<String, Exercise>> exercises =
          _deserializeExercises(preferences);
      this.exercises.addEntries(exercises);
    }

    if (preferences.containsKey("workouts")) {
      Iterable<MapEntry<String, Workout>> workouts =
          _deserializeWorkouts(preferences);
      this.workouts.addEntries(workouts);
    }
    if (preferences.containsKey("workoutRoutines")) {
      Iterable<MapEntry<String, WorkoutRoutine>> workoutRoutines =
          _deserializeWorkoutRoutines(preferences);
      this.workoutRoutines.addEntries(workoutRoutines);
    }

    if (preferences.containsKey("activeWorkoutRoutine")) {
      activeWorkoutRoutine =
          workoutRoutines[preferences.getString("activeWorkoutRoutine")];
    }
    loaded = true;

    exerciseObserver = autorun((_) {
      exercises.length;
      exercises.values?.forEach((e) {
        var p = e?.getProgression();
        if (p != null) {
          p.values?.forEach((progression) {
            progression?.sets?.forEach((workoutSet) {
              workoutSet?.reps;
              workoutSet?.weight;
            });
          });
        }
      });
      updateExercises();
    });
    workoutObserver = autorun((_) {
      workouts.length;
      updateWorkouts();
    });
    workoutRoutineObserver = autorun((_) {
      workoutRoutines.length;
      updateWorkoutRoutines();
    });
    activeWorkoutRoutineObserver = autorun((_) {
      if (activeWorkoutRoutine != null) {
        activeWorkoutRoutine.workouts;
      }
      updateActiveWorkoutRoutine();
    });
  }

  Iterable<MapEntry<String, Exercise>> _deserializeExercises(
      SharedPreferences preferences) {
    Iterable<MapEntry<String, Exercise>> exercises =
        preferences.getStringList("exercises").map((raw) {
      Exercise deserialized = JsonMapper.deserialize<Exercise>(raw);
      deserialized.setProgression(ObservableMap.of(
          _deserializeProgression(deserialized.progressionRaw)));
      return MapEntry(deserialized.id, deserialized);
    });
    return exercises;
  }

  Map<DateTime, Progression> _deserializeProgression(List<String> raw) {
    var entries = raw.map((e) {
      Progression deserialized = JsonMapper.deserialize<Progression>(e);
      deserialized.setSets(ObservableList.of(deserialized.rawSets
          .map((e) => JsonMapper.deserialize<WorkoutSet>(e))));
      return MapEntry(deserialized.date, deserialized);
    });
    return Map.fromEntries(entries);
  }

  Iterable<MapEntry<String, Workout>> _deserializeWorkouts(
      SharedPreferences preferences) {
    var workouts = preferences.getStringList("workouts").map((raw) {
      Workout workout = JsonMapper.deserialize<Workout>(raw);
      workout.setExercises(
          ObservableList.of(workout.exerciseIds.map((id) => exercises[id])));
      return MapEntry(workout.id, workout);
    });
    return workouts;
  }

  Iterable<MapEntry<String, WorkoutRoutine>> _deserializeWorkoutRoutines(
      SharedPreferences preferences) {
    Iterable<MapEntry<String, WorkoutRoutine>> workoutRoutines =
        preferences.getStringList("workoutRoutines").map((raw) {
      WorkoutRoutine routine = JsonMapper.deserialize<WorkoutRoutine>(raw);
      routine.setWorkouts(ObservableList.of(routine.rawWorkoutDays.map((e) {
        var workoutDay = JsonMapper.deserialize<WorkoutDay>(e);
        if (!workoutDay.isRestDay) {
          workoutDay.setWorkout(workouts[workoutDay.workoutId]);
        }
        return workoutDay;
      })));
      return MapEntry(routine.id, routine);
    });
    return workoutRoutines;
  }

  Future<List<String>> updateExercises() async {
    var exercises = this.exercises.values;
    var json = exercises.map((exercise) {
      exercise.progressionRaw.clear();
      exercise.progressionRaw
          .addAll(exercise.getProgression().values.map((element) {
        element.rawSets.clear();
        element.rawSets.addAll(
            element.sets.map((element) => JsonMapper.serialize(element)));
        return JsonMapper.serialize(element);
      }));
      return JsonMapper.serialize(exercise);
    }).toList();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList("exercises", json);
    return json;
  }

  Future<List<String>> updateWorkouts() async {
    var workouts = this.workouts.values;
    workouts.forEach((workout) {
      workout.exerciseIds.clear();
      workout.exerciseIds
          .addAll(workout.exercises.map((exercise) => exercise.id));
    });
    var json =
        workouts.map((workout) => JsonMapper.serialize(workout)).toList();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList("workouts", json);
    return json;
  }

  Future<List<String>> updateWorkoutRoutines() async {
    var workoutRoutines = this.workoutRoutines.values;
    workoutRoutines.forEach((workoutRoutine) {
      workoutRoutine.rawWorkoutDays.clear();
      workoutRoutine.rawWorkoutDays.addAll(workoutRoutine.workouts
          .map((workout) => JsonMapper.serialize(workout)));
    });
    var json = workoutRoutines.map((e) => JsonMapper.serialize(e)).toList();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList("workoutRoutines", json);
    return json;
  }

  Future<String> updateActiveWorkoutRoutine() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (activeWorkoutRoutine != null) {
      preferences.setString("activeWorkoutRoutine", activeWorkoutRoutine.id);
      return activeWorkoutRoutine.id;
    }
    return null;
  }
}
