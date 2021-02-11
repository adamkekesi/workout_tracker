import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/exercises/exercise_editor_screen/exercise_editor_screen.dart';
import 'package:workout_tracker/screens/workouts/components/exercise_display.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';

class AddExerciseModalContent extends StatelessWidget {
  const AddExerciseModalContent({
    Key key,
    @required this.alreadyChosen,
    @required this.preferences,
  }) : super(key: key);

  final PreferenceStore preferences;

  final List<Exercise> alreadyChosen;

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
            child: FlatButton(
                onPressed: () => _openExerciseCreatorScreen(context),
                child: Text(
                  "Új gyakorlat",
                  style: TextStyle(color: brightColor),
                )),
          ),
          Observer(
            builder: (context) {
              var exercises = preferences.exercises.values
                  .where((element) => !alreadyChosen.contains(element))
                  .toList();

              return Expanded(
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) => ExerciseDisplay(
                          exercise: exercises[index],
                          onTap: () {
                            Exercise selected = exercises[index];
                            Navigator.pop(context, selected);
                          },
                          trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _openExerciseEditorScreen(
                                  context, exercises[index])),
                        ),
                    separatorBuilder: (context, index) => Divider(
                          color: redColor,
                        ),
                    itemCount: exercises.length),
              );
            },
          )
        ],
      ),
    );
  }

  void _openExerciseCreatorScreen(BuildContext context) async {
    Exercise result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExerciseEditorScreen.createNewExerciseScreen(),
        ));
    if (result != null) {
      preferences.exercises.addEntries([MapEntry(result.id, result)]);
      Navigator.pop(context, result);
    }
  }

  void _openExerciseEditorScreen(
      BuildContext context, Exercise exercise) async {
    var delete = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExerciseEditorScreen.createEditorScreen(initial: exercise),
        ));

    if (delete == true) {
      preferences.deleteExercise(exercise);
    }
  }
}
