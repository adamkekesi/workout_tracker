import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/progression/progression_history_screen/date_picker_modal_content.dart';
import 'package:workout_tracker/screens/progression/progression_history_screen/progression_history_screen.dart';
import 'package:workout_tracker/screens/progression/workout_progression_editor_screen/workout_progression_editor_screen.dart';
import 'package:workout_tracker/screens/workout_routines/components/workout_display.dart';
import 'package:workout_tracker/screens/workouts/components/exercise_display.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/widgets/app_title.dart';
import 'package:workout_tracker/widgets/list_separator.dart';
import 'package:workout_tracker/widgets/sidebar.dart';

class ProgressionScreen extends StatelessWidget {
  static const routeName = "/progression";

  final _preferences = getStore();

  ProgressionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTitle(
          screenTitle: "Fejlődés",
        ),
        backgroundColor: redColor,
      ),
      body: Observer(
          builder: (BuildContext context) => ListView.separated(
              itemBuilder: (context, index) {
                var workout = _preferences.workouts.values.elementAt(index);
                return ExpansionTile(
                  title: WorkoutDisplay(
                    workout: workout,
                    onTap: null,
                  ),
                  children: [
                    ...workout.exercises.map((exercise) {
                      var latestProgression = exercise.latestProgression;
                      String latestDate;
                      if (latestProgression != null) {
                        latestDate = DateFormat("yyyy. MMMM. dd.", "hu")
                            .format(latestProgression.date);
                      }
                      return Card(
                        child: Column(
                          children: [
                            ExerciseDisplay(exercise: exercise, onTap: null),
                            Divider(
                              thickness: 1,
                            ),
                            if (latestProgression != null)
                              ListTile(
                                onLongPress: () => _openLatest(
                                    context, latestProgression.date, workout),
                                title: Text("Legutóbbi edzés: $latestDate"),
                                subtitle: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "${latestProgression.highestWeight} kg, ${latestProgression.highWeightSets} sorozatra"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "${latestProgression.numSets} munkasorozat"),
                                    )
                                  ],
                                ),
                              ),
                            ListTile(
                              title: Text(
                                  "Legmagasabb súly: ${exercise.highestWeight} kg"),
                            )
                          ],
                        ),
                      );
                    }),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 30,
                              color: brightColor,
                            ),
                            onPressed: () =>
                                _openProgressionCreator(context, workout),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.history,
                              color: brightColor,
                            ),
                            onPressed: () => _openHistory(context, workout),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => ListSeparator(),
              itemCount: _preferences.workouts.length)),
      drawer: Sidebar(),
    );
  }

  void _openHistory(BuildContext context, Workout workout) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProgressionHistoryScreen(workout: workout),
        ));
  }

  void _openProgressionCreator(BuildContext context, Workout workout) async {
    DateTime date = await showMaterialModalBottomSheet(
      context: context,
      builder: (context, controller) => DatePickerModalContent(),
    );
    if (date != null) {
      date = DateTime.utc(date.year, date.month, date.day);
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WorkoutProgressionEditorScreen(workout: workout, date: date),
          ));
    }
  }

  void _openLatest(BuildContext context, DateTime date, Workout workout) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WorkoutProgressionEditorScreen(workout: workout, date: date),
        ));
  }
}
