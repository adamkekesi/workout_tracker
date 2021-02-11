import 'package:flutter/material.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/exercises/exercise_editor_screen/components/exercise_name_input.dart';
import 'package:workout_tracker/screens/exercises/exercise_editor_screen/components/sets_input.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/widgets/inputs/styled_text_input.dart';
import 'package:workout_tracker/widgets/submit_button.dart';

class ExerciseEditorScreen extends StatefulWidget {
  final Exercise initial;

  ExerciseEditorScreen.createEditorScreen({Key key, @required this.initial})
      : super(key: key);

  ExerciseEditorScreen.createNewExerciseScreen({Key key})
      : initial = null,
        super(key: key);

  @override
  _ExerciseEditorScreenState createState() => _ExerciseEditorScreenState();
}

class _ExerciseEditorScreenState extends State<ExerciseEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _formInputWidthPercent = 0.75;

  final _preferences = getStore();

  TextEditingController _exerciseNameController;

  TextEditingController _exerciseSetsController;

  TextEditingController _exerciseRepsLowController;

  TextEditingController _exerciseRepsHighController;

  Exercise _initial;

  bool get _hasInitialValue => _initial != null;

  String get _appBarTitle =>
      _hasInitialValue ? "Gyakorlat szerkesztése" : "Új gyakorlat";

  String get _submitTitle => _hasInitialValue ? "Szerkesztés" : "Hozzáadás";

  @override
  void initState() {
    super.initState();
    _initial = widget.initial;
    _exerciseNameController = TextEditingController(text: _initial?.name);
    _exerciseSetsController =
        TextEditingController(text: _initial?.idealSets?.toString());
    _exerciseRepsLowController =
        TextEditingController(text: _initial?.idealRepsLow?.toString());
    _exerciseRepsHighController =
        TextEditingController(text: _initial?.idealRepsHigh?.toString());
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var formSize = _formInputWidthPercent * screenWidth;
    var repInputSize = 0.45 * formSize;
    var separatorSize = 0.1 * formSize;

    return Container(
      child: Scaffold(
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
                  horizontal: (screenWidth - formSize) / 2),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ExerciseNameInput(
                          controller: _exerciseNameController,
                          preferences: _preferences,
                          initial: _initial),
                      SetsInput(
                        controller: _exerciseSetsController,
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Ismétlés",
                            style: Theme.of(context).textTheme.subtitle1,
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 26),
                        child: Row(
                          children: [
                            Container(
                              width: repInputSize,
                              child: StyledTextInput(
                                controller: _exerciseRepsLowController,
                                validator: _validator,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: separatorSize,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "-",
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                            Container(
                              width: repInputSize,
                              child: StyledTextInput(
                                controller: _exerciseRepsHighController,
                                validator: (value) {
                                  var result = _validator(value);
                                  if (result != null) {
                                    return result;
                                  }
                                  var lowResult = _validator(
                                      _exerciseRepsLowController.text);
                                  if (lowResult != null) {
                                    return null;
                                  }
                                  int lowValue = int.tryParse(
                                      _exerciseRepsLowController.text);
                                  int highValue = int.tryParse(value);
                                  if (highValue < lowValue) {
                                    return "Az elsőt, vagy az elsőnél nagyobb számot adj meg.";
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(errorMaxLines: 3),
                              ),
                            )
                          ],
                        ),
                      ),
                      SubmitButton(
                        title: _submitTitle,
                        onSubmit: () => _submitForm(context),
                      )
                    ],
                  ))),
        ),
      ),
    );
  }

  String _validator(String value) {
    if (value.isEmpty) {
      return "Ezt a mezőt üresen hagytad.";
    }
    int parsed = int.tryParse(value);
    if (parsed == null) {
      return "Nem egy egész számot adtál meg.";
    }
    if (parsed < 1) {
      return "0-nál nagyobb számot adj meg.";
    }
    return null;
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (_hasInitialValue) {
        _initial.name = _exerciseNameController.text;
        _initial.idealSets = int.parse(_exerciseSetsController.text);
        _initial.idealRepsLow = int.parse(_exerciseRepsLowController.text);
        _initial.idealRepsHigh = int.parse(_exerciseRepsHighController.text);
        return Navigator.pop(context, false);
      }
      var exercise = Exercise.create(
          _exerciseNameController.text,
          int.parse(_exerciseSetsController.text),
          int.parse(_exerciseRepsLowController.text),
          int.parse(_exerciseRepsHighController.text));

      Navigator.pop(context, exercise);
    }
  }

  void _deleteExercise(BuildContext context) {
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    super.dispose();
    _exerciseNameController.dispose();
    _exerciseSetsController.dispose();
    _exerciseRepsLowController.dispose();
    _exerciseRepsHighController.dispose();
  }
}
