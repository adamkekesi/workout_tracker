import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/exercises/exercise_editor_screen/exercise_editor_screen.dart';
import 'package:workout_tracker/screens/workout_routines/components/workout_display.dart';
import 'package:workout_tracker/screens/workouts/components/exercise_display.dart';
import 'package:workout_tracker/screens/workouts/workout_editor_screen/workout_editor_screen.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/stores/workout_day/workout_day.dart';

class SelectWorkoutModalContent extends StatelessWidget {
  const SelectWorkoutModalContent({
    Key key,
    @required this.preferences,
  }) : super(key: key);

  final PreferenceStore preferences;

  final _modalHeightPercent = 0.7;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _modalHeightPercent * MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: ButtonBar(
              children: [
                FlatButton(
                    onPressed: () => _submitRestDay(context),
                    child: Text(
                      "Pihenőnap",
                      style: TextStyle(color: brightColor),
                    )),
                FlatButton(
                    onPressed: () => _openWorkoutCreatorScreen(context),
                    child: Text(
                      "Új edzés",
                      style: TextStyle(color: brightColor),
                    ))
              ],
            ),
          ),
          Observer(
            builder: (context) {
              var workouts = preferences.workouts.values.toList();

              return Expanded(
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) => WorkoutDisplay(
                          workout: workouts[index],
                          onTap: () {
                            Workout selected = workouts[index];
                            Navigator.pop(
                                context, new WorkoutDay.workoutDay(selected));
                          },
                          trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _openWorkoutEditorScreen(
                                  context, workouts[index])),
                        ),
                    separatorBuilder: (context, index) => Divider(
                          color: redColor,
                        ),
                    itemCount: workouts.length),
              );
            },
          )
        ],
      ),
    );
  }

  void _openWorkoutCreatorScreen(BuildContext context) async {
    Workout result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutEditorScreen.createNewWorkoutScreen(),
        ));
    if (result != null) {
      preferences.workouts.addEntries([MapEntry(result.id, result)]);
      Navigator.pop(context, WorkoutDay.workoutDay(result));
    }
  }

  void _openWorkoutEditorScreen(BuildContext context, Workout workout) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WorkoutEditorScreen.createEditorScreen(initial: workout),
        ));
  }

  void _submitRestDay(BuildContext context) {
    Navigator.pop(context, WorkoutDay.restDay());
  }
}
