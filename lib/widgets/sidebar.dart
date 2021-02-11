import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/landing_screen.dart';
import 'package:workout_tracker/screens/progression/progression_screen.dart';
import 'package:workout_tracker/screens/workout_routines/workout_routines_screen.dart';
import 'package:workout_tracker/screens/workouts/workouts_screen.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/widgets/list_separator.dart';

class Sidebar extends StatelessWidget {
  PreferenceStore _preferences = getStore();

  Sidebar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: [
            ListTile(
              title: Container(
                child: Text(
                  'Edzések',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                padding: const EdgeInsets.all(30.0),
              ),
              onTap: () => _navigate(context, WorkoutsScreen.routeName),
            ),
            ListSeparator(),
            ListTile(
              title: Container(
                child: Text(
                  'Edzéstervek',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                padding: const EdgeInsets.all(30.0),
              ),
              onTap: () => _navigate(context, WorkoutRoutinesScreen.routeName),
            ),
            ListSeparator(),
            ListTile(
              title: Container(
                child: Text(
                  'Fejlődés',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                padding: const EdgeInsets.all(30.0),
              ),
              onTap: () => _navigate(context, ProgressionScreen.routeName),
            ),
            ListSeparator(),
            ListTile(
              title: Text("Elmentett adatok"),
              onTap: () => _showPreferences(context),
            )
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    if (ModalRoute.of(context).settings.name == route) {
      Navigator.pop(context);
      return;
    }
    Navigator.of(context)
      ..popUntil(ModalRoute.withName(LandingScreen.routeName))
      ..pushNamed(route);
  }

  void _showPreferences(BuildContext context) async {
    var content = SingleChildScrollView(
      child: Column(
        children: [
          Text("exercises:"),
          TextField(
            readOnly: true,
            maxLines: null,
            controller: TextEditingController(
                text: (await _preferences.updateExercises()).join("\n\n")),
          ),
          Text("workouts:"),
          TextField(
            readOnly: true,
            maxLines: null,
            controller: TextEditingController(
                text: (await _preferences.updateWorkouts()).join("\n\n")),
          ),
          Text("workoutRoutines:"),
          TextField(
            readOnly: true,
            maxLines: null,
            controller: TextEditingController(
                text:
                    (await _preferences.updateWorkoutRoutines()).join("\n\n")),
          ),
          Text("activeWorkoutRoutine:"),
          TextField(
            readOnly: true,
            maxLines: null,
            controller: TextEditingController(
                text: (await _preferences.updateActiveWorkoutRoutine())),
          ),
        ],
      ),
    );
    showMaterialModalBottomSheet(
      context: context,
      builder: (context, controller) => Container(
        height: 0.9 * MediaQuery.of(context).size.height,
        child: content,
      ),
    );
  }
}
