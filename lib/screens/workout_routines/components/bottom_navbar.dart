import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/workout_routines/workout_routine_editor/workout_routine_editor_screen.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout_routine/workout_routine.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    Key key,
    @required PreferenceStore preferences,
  })  : _preferences = preferences,
        super(key: key);

  final PreferenceStore _preferences;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 1,
        )
      ]),
      child: Material(
        color: redColor,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.12,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Observer(
                  builder: (context) {
                    if (_preferences.workoutRoutines.length == 0) {
                      return Text(
                        "Nincs még egy edzésterved sem.",
                        maxLines: 2,
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.4),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      child: InkWell(
                        onTap: () {},
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<WorkoutRoutine>(
                            isExpanded: true,
                            iconSize: 0,
                            value: _preferences.activeWorkoutRoutine,
                            items: _preferences.workoutRoutines.values
                                .map((e) => DropdownMenuItem<WorkoutRoutine>(
                                      child: ListTile(
                                        title: Text(
                                          e.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _openWorkoutRoutineEditor(
                                                  context, e);
                                            }),
                                        onTap: () {
                                          _preferences.activeWorkoutRoutine = e;
                                          Navigator.pop(context);
                                        },
                                      ),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (workoutRoutine) {
                              _preferences.activeWorkoutRoutine =
                                  workoutRoutine;
                            },
                            selectedItemBuilder: (context) => _preferences
                                .workoutRoutines.values
                                .map((e) => Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        e.name,
                                        style: TextStyle(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text(
                      "Új edzésterv",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _openWorkoutRoutineCreator(context),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openWorkoutRoutineCreator(BuildContext context) async {
    var result = await Navigator.push<WorkoutRoutine>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WorkoutRoutineEditorScreen.createNewWorkoutRoutineScreen(),
        ));
    if (result != null) {
      _preferences.workoutRoutines.addEntries([MapEntry(result.id, result)]);
    }
  }

  void _openWorkoutRoutineEditor(
      BuildContext context, WorkoutRoutine workoutRoutine) async {
    var delete = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutRoutineEditorScreen.createEditorScreen(
              initial: workoutRoutine),
        ));

    if (delete == true) {
      _preferences.deleteWorkoutRoutine(workoutRoutine);
    }
  }
}
