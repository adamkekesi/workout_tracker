import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/workout_routines/components/select_workout_modal_content.dart';
import 'package:workout_tracker/screens/workout_routines/components/workout_display.dart';
import 'package:workout_tracker/screens/workout_routines/components/workout_routine_name_input.dart';
import 'package:workout_tracker/screens/workouts/workout_editor_screen/workout_editor_screen.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/stores/workout_day/workout_day.dart';
import 'package:workout_tracker/stores/workout_routine/workout_routine.dart';
import 'package:workout_tracker/widgets/inputs/date_picker_input/date_picker_input.dart';
import 'package:workout_tracker/widgets/inputs/multiple_picker_input/multiple_picker_input.dart';
import 'package:workout_tracker/widgets/submit_button.dart';

class WorkoutRoutineEditorScreen extends StatefulWidget {
  final WorkoutRoutine initial;

  WorkoutRoutineEditorScreen.createEditorScreen(
      {Key key, @required this.initial})
      : super(key: key);

  WorkoutRoutineEditorScreen.createNewWorkoutRoutineScreen({Key key})
      : initial = null,
        super(key: key);

  @override
  _WorkoutRoutineEditorScreenState createState() =>
      _WorkoutRoutineEditorScreenState();
}

class _WorkoutRoutineEditorScreenState
    extends State<WorkoutRoutineEditorScreen> {
  final _formInputWidthPercent = 0.75;

  final _preferences = getStore();

  final _pickerKey = GlobalKey<FormFieldState<List<WorkoutDay>>>();

  final _formKey = GlobalKey<FormState>();

  final _datePickerKey = GlobalKey<FormFieldState<DateTime>>();

  TextEditingController _workoutRoutineNameController;

  WorkoutRoutine _initial;

  bool get _hasInitialValue => _initial != null;

  String get _appBarTitle => _hasInitialValue
      ? "Edzésterv szerkesztése"
      : "Új edzésterv felvétele a listára";

  String get _submitTitle => _hasInitialValue ? "Szerkesztés" : "Hozzáadás";

  @override
  void initState() {
    super.initState();
    _initial = widget.initial;
    _workoutRoutineNameController = TextEditingController(text: _initial?.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        backgroundColor: redColor,
        actions: [
          if (_hasInitialValue)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () => _deleteExercise(context),
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: ((1 - _formInputWidthPercent) / 2) *
                  MediaQuery.of(context).size.width),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                WorkoutRoutineNameInput(
                    controller: _workoutRoutineNameController,
                    initial: _initial,
                    preferences: _preferences),
                MultiplePickerInput<WorkoutDay>(
                  key: _pickerKey,
                  initialValue: _initial?.workouts?.toList() ?? [],
                  displayBuilder: (workout) => [
                    if (workout.isRestDay)
                      ListTile(
                        title: Text("Pihenőnap"),
                      ),
                    if (!workout.isRestDay)
                      WorkoutDisplay(
                        workout: workout.workout,
                        onTap: () =>
                            _openWorkoutEditorScreen(context, workout.workout),
                      )
                  ],
                  title: Text(
                    "Edzések",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .apply(color: Colors.grey[700]),
                  ),
                  addNewItemText: "Edzés hozzáadása",
                  onAddNewItem: () => _openWorkoutSelectorModal(context),
                ),
                DatePickerInput(
                    key: _datePickerKey,
                    initialValue: _initial?.startDate,
                    validator: (value) {
                      if (value == null) {
                        return "Add meg a kezdés dátumát.";
                      }
                      return null;
                    },
                    title: Text(
                      "Edzésterv első napja",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .apply(color: Colors.grey[700]),
                    )),
                SubmitButton(
                  title: _submitTitle,
                  onSubmit: () => _submitForm(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openWorkoutSelectorModal(BuildContext context) async {
    var selected = await showMaterialModalBottomSheet<WorkoutDay>(
      context: context,
      builder: (context, controller) =>
          SelectWorkoutModalContent(preferences: _preferences),
    );
    if (selected != null) {
      _pickerKey.currentState
          .didChange(_pickerKey.currentState.value..add(selected));
    }
  }

  void _openWorkoutEditorScreen(BuildContext context, Workout workout) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WorkoutEditorScreen.createEditorScreen(initial: workout),
        ));
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var startDate = _datePickerKey.currentState.value;
      startDate = DateTime.utc(startDate.year, startDate.month, startDate.day);
      if (_hasInitialValue) {
        _initial.name = _workoutRoutineNameController.text;
        _initial.startDate = startDate;
        _initial.setWorkouts(ObservableList.of(_pickerKey.currentState.value));
        return Navigator.pop(context, false);
      }
      WorkoutRoutine workoutRoutine = WorkoutRoutine.create(
          _workoutRoutineNameController.text,
          _pickerKey.currentState.value,
          startDate);
      Navigator.pop(context, workoutRoutine);
    }
  }

  void _deleteExercise(BuildContext context) {
    Navigator.pop(context, true);
  }
}
