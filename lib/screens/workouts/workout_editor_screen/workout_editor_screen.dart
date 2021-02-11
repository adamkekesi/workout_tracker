import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/exercises/exercise_editor_screen/exercise_editor_screen.dart';
import 'package:workout_tracker/screens/workouts/components/add_exercise_modal_content.dart';
import 'package:workout_tracker/screens/workouts/components/exercise_display.dart';
import 'package:workout_tracker/screens/workouts/components/workout_name_input.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/widgets/inputs/multiple_picker_input/multiple_picker_input.dart';
import 'package:workout_tracker/widgets/inputs/styled_text_input.dart';
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import 'package:workout_tracker/widgets/submit_button.dart';

class WorkoutEditorScreen extends StatefulWidget {
  final Workout initial;

  WorkoutEditorScreen.createEditorScreen({Key key, @required this.initial})
      : super(key: key);

  WorkoutEditorScreen.createNewWorkoutScreen({Key key})
      : initial = null,
        super(key: key);

  @override
  _WorkoutEditorScreenState createState() => _WorkoutEditorScreenState();
}

class _WorkoutEditorScreenState extends State<WorkoutEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _pickerKey = GlobalKey<FormFieldState<List<Exercise>>>();

  final _formInputWidthPercent = 0.75;

  final _preferences = getStore();

  Workout _initial;

  TextEditingController _workoutNameController;

  bool get _hasInitialValue => _initial != null;

  String get _appBarTitle =>
      _hasInitialValue ? "Edzés szerkesztése" : "Új edzés felvétele a listára";

  String get _submitTitle => _hasInitialValue ? "Szerkesztés" : "Hozzáadás";

  @override
  void initState() {
    super.initState();
    _initial = widget.initial;
    _workoutNameController = TextEditingController(text: _initial?.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        backgroundColor: redColor,
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
                  WorkoutNameInput(
                      controller: _workoutNameController,
                      preferences: _preferences,
                      initial: _initial),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: MultiplePickerInput<Exercise>(
                      key: _pickerKey,
                      addNewItemText: "Gyakorlat hozzáadása",
                      onAddNewItem: () => _openExerciseSelectorModal(context),
                      initialValue: _initial?.exercises?.toList() ?? [],
                      title: Text(
                        "Gyakorlatok",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .apply(color: Colors.grey[700]),
                      ),
                      displayBuilder: (item) => [
                        ExerciseDisplay(
                          exercise: item,
                          onTap: () => _openExerciseEditorModal(context, item),
                        )
                      ],
                    ),
                  ),
                  SubmitButton(
                    onSubmit: () => _submitForm(context),
                    title: _submitTitle,
                  )
                ],
              )),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (_hasInitialValue) {
        _initial.name = _workoutNameController.text;
        _initial.setExercises(ObservableList.of(_pickerKey.currentState.value));
        return Navigator.pop(context);
      }
      Workout workout = Workout.create(
          _workoutNameController.text, _pickerKey.currentState.value);
      Navigator.pop(context, workout);
    }
  }

  void _openExerciseSelectorModal(BuildContext context) async {
    var selected = await showMaterialModalBottomSheet<Exercise>(
      context: context,
      builder: (context, controller) => AddExerciseModalContent(
        preferences: _preferences,
        alreadyChosen: _pickerKey.currentState?.value,
      ),
    );
    if (selected != null) {
      var value = _pickerKey.currentState.value..add(selected);
      _pickerKey.currentState.didChange(value);
    }
  }

  void _openExerciseEditorModal(BuildContext context, Exercise exercise) async {
    var delete = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExerciseEditorScreen.createEditorScreen(initial: exercise),
        ));

    if (delete == true) {
      var value = _pickerKey.currentState.value..remove(exercise);
      _pickerKey.currentState.didChange(value);
      _preferences.deleteExercise(exercise);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _workoutNameController.dispose();
  }
}
