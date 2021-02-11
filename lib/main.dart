import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper;
import 'package:dart_json_mapper_mobx/dart_json_mapper_mobx.dart'
    show mobXAdapter;
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/landing_screen.dart';
import 'package:workout_tracker/screens/progression/progression_screen.dart';
import 'package:workout_tracker/screens/workout_routines/workout_routines_screen.dart';
import 'package:workout_tracker/screens/workouts/workouts_screen.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';

import 'main.reflectable.dart' show initializeReflectable;

void main() {
  initializeReflectable();
  JsonMapper().useAdapter(mobXAdapter);

  runApp(WorkoutApp());
  getStore().loadFromPreferences();
}

class WorkoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edzés segéd',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[400],
        splashColor: Color.fromARGB(128, 80, 80, 80),
      ),
      supportedLocales: <Locale>[Locale("hu", "HU")],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: Locale("hu", "HU"),
      routes: {
        WorkoutsScreen.routeName: (BuildContext context) => WorkoutsScreen(),
        WorkoutRoutinesScreen.routeName: (BuildContext context) =>
            WorkoutRoutinesScreen(),
        LandingScreen.routeName: (BuildContext context) => LandingScreen(),
        ProgressionScreen.routeName: (BuildContext context) =>
            ProgressionScreen()
      },
      initialRoute: LandingScreen.routeName,
    );
  }
}
