import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/workouts/workouts_screen.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import "package:workout_tracker/stores/preference-store/preference-store.dart";
import 'package:workout_tracker/widgets/app_title.dart';
import 'package:workout_tracker/widgets/sidebar.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = "/";

  final store = getStore();

  LandingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        title: AppTitle(
          screenTitle: "Kezdőlap",
        ),
      ),
      drawer: Sidebar(),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Observer(
                builder: (_) =>
                    Text(store.exercises.values.map((e) => e.name).join(", "))),
          )
        ],
      ),
    );
  }
}
