import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/screens/exercises/exercise_editor_screen/exercise_editor_screen.dart';
import 'package:workout_tracker/screens/progression/workout_progression_editor_screen/workout_progression_editor_screen.dart';
import 'package:workout_tracker/screens/workout_routines/components/bottom_navbar.dart';
import 'package:workout_tracker/screens/workout_routines/workout_routine_calendar_store.dart';
import 'package:workout_tracker/screens/workouts/components/exercise_display.dart';
import 'package:workout_tracker/screens/workouts/workout_editor_screen/workout_editor_screen.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/preference-store/preference-store.dart';
import 'package:workout_tracker/stores/workout/workout.dart';
import 'package:workout_tracker/widgets/app_title.dart';
import 'package:workout_tracker/widgets/sidebar.dart';

class WorkoutRoutinesScreen extends StatefulWidget {
  static const routeName = "/workout-routines";

  WorkoutRoutinesScreen({Key key}) : super(key: key);

  @override
  _WorkoutRoutinesScreenState createState() => _WorkoutRoutinesScreenState();
}

class _WorkoutRoutinesScreenState extends State<WorkoutRoutinesScreen> {
  final PreferenceStore _preferences = getStore();

  CalendarController _controller;

  WorkoutRoutineCalendarStore _store = WorkoutRoutineCalendarStore();

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _store.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        title: AppTitle(
          screenTitle: "Edzéstervek",
        ),
      ),
      drawer: Sidebar(),
      bottomNavigationBar: BottomNavbar(preferences: _preferences),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Observer(
                builder: (context) {
                  _store.workouts.length;
                  if (_preferences.activeWorkoutRoutine == null) {
                    return Container();
                  }
                  return TableCalendar(
                    calendarController: _controller,
                    events: _store.workouts,
                    weekendDays: [],
                    locale: "hu_HU",
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    initialCalendarFormat: CalendarFormat.month,
                    availableCalendarFormats: {
                      CalendarFormat.month: "Hónap",
                      CalendarFormat.twoWeeks: "2 hét",
                      CalendarFormat.week: "Hét"
                    },
                    availableGestures: AvailableGestures.horizontalSwipe,
                    calendarStyle: CalendarStyle(
                      weekdayStyle: TextStyle(color: Colors.black),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    builders: CalendarBuilders(
                        markersBuilder: (context, date, events, holidays) => [],
                        dayBuilder: _dayBuilder,
                        outsideDayBuilder: (context, date, events) => Opacity(
                              opacity: 0.3,
                              child: _dayBuilder(context, date, events),
                            ),
                        selectedDayBuilder: _selectedDayBuilder),
                    onCalendarCreated: (first, last, format) {
                      Future.microtask(
                          () => _store.updateVisibleDates(first, last));
                    },
                    onVisibleDaysChanged: (first, last, format) {
                      Future.microtask(
                          () => _store.updateVisibleDates(first, last));
                    },
                    onDaySelected: (day, events) {
                      Future.microtask(() => _store.updateSelectedDate(day));
                    },
                  );
                },
              ),
              Observer(
                builder: (context) {
                  if (_store.selectedWorkout == null) {
                    return Container();
                  }
                  return Container(
                    margin: EdgeInsets.only(top: 30, left: 15, right: 15),
                    child: WorkoutCard(
                      date: _store.selectedDate,
                      workout: _store.selectedWorkout,
                      preferences: _preferences,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _dayBuilder(context, date, events) {
    if ((events != null && events.length > 0)) {
      return Container(
        margin: EdgeInsets.all(7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: brightColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Text(date.day.toString(), style: TextStyle(color: Colors.white)),
      );
    }
    return Container(
      margin: EdgeInsets.all(7),
      alignment: Alignment.center,
      child: Text(date.day.toString()),
    );
  }

  Widget _selectedDayBuilder(context, date, events) {
    if ((events != null && events.length > 0)) {
      return Container(
        margin: EdgeInsets.all(7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: brightColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: Colors.white, width: 3)),
        child: Text(date.day.toString(), style: TextStyle(color: Colors.white)),
      );
    }
    return Container(
      margin: EdgeInsets.all(7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Colors.white, width: 3)),
      child: Text(date.day.toString()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _store.dispose();
    _controller.dispose();
  }
}

class WorkoutCard extends StatelessWidget {
  const WorkoutCard(
      {Key key,
      @required this.date,
      @required this.workout,
      @required this.preferences})
      : super(key: key);

  final DateTime date;

  final Workout workout;

  final PreferenceStore preferences;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: () => _openWorkoutEditor(context, workout),
            title: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
              child: Text(
                DateFormat("yyyy. MMMM. dd.", "hu").format(
                  date,
                ),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
            subtitle: Observer(
              builder: (context) => Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Text(
                      workout.name,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ...workout.exercises.map((element) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: ExerciseDisplay(
                              exercise: element,
                              onTap: null,
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () =>
                                      _openExerciseEditor(context, element)),
                            )),
                      )),
                  ButtonBar(
                    children: [
                      FlatButton(
                          onPressed: () => _openProgression(context, workout),
                          child: Text(
                            "Fejlődés",
                            style: TextStyle(color: brightColor),
                          ))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _openWorkoutEditor(BuildContext context, Workout workout) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WorkoutEditorScreen.createEditorScreen(initial: workout),
        ));
  }

  void _openExerciseEditor(BuildContext context, Exercise exercise) async {
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

  void _openProgression(BuildContext context, Workout workout) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutProgressionEditorScreen(
            workout: workout,
            date: date,
          ),
        ));
  }
}
