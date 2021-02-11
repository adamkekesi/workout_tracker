import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/workouts/components/workout_display.dart';
import 'package:workout_tracker/screens/workouts/workout_editor_screen/workout_editor_screen.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import "package:workout_tracker/stores/preference-store/preference-store.dart";
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/widgets/app_title.dart';
import 'package:workout_tracker/widgets/list_separator.dart';
import 'package:workout_tracker/widgets/sidebar.dart';

class WorkoutsScreen extends StatelessWidget {
  static const routeName = "/workouts";

  final _preferences = getStore();

  WorkoutsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        title: AppTitle(
          screenTitle: "Edzések",
        ),
      ),
      drawer: Sidebar(),
      body: Observer(
        builder: (context) => ListView.separated(
          itemCount: _preferences.workouts.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          separatorBuilder: (BuildContext context, int index) =>
              ListSeparator(),
          itemBuilder: (BuildContext context, int index) {
            Workout item = _preferences.workouts.values.elementAt(index);
            return WorkoutDisplay(
              workout: item,
              onTap: () => _openWorkoutEditor(context, item),
              onDelete: () => _deleteWorkout(item),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openWorkoutCreator(context),
        child: Center(
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ),
        backgroundColor: lightColor,
      ),
    );
  }

  void _openWorkoutCreator(BuildContext context) async {
    var result = await Navigator.push<Workout>(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkoutEditorScreen.createNewWorkoutScreen()));
    if (result != null) {
      _preferences.workouts.addEntries([MapEntry(result.id, result)]);
    }
  }

  void _openWorkoutEditor(BuildContext context, Workout initial) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WorkoutEditorScreen.createEditorScreen(initial: initial),
        ));
  }

  void _deleteWorkout(Workout workout) {
    _preferences.deleteWorkout(workout);
  }
}
