import 'package:flutter/material.dart';
import 'package:workout_tracker/config/colors.dart';
import 'package:workout_tracker/stores/exercise/exercise.dart';
import 'package:workout_tracker/stores/identifiable.dart';
import 'package:workout_tracker/widgets/inputs/multiple_picker_input/add_new_item_button.dart';
import 'package:workout_tracker/widgets/inputs/multiple_picker_input/chosen_item_display.dart'
    show PositionChange, ChosenItemDisplay;
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";

class MultiplePickerInput<T extends Identifiable> extends FormField<List<T>> {
  MultiplePickerInput(
      {Key key,
      FormFieldSetter<List<T>> onSaved,
      FormFieldValidator<List<T>> validator,
      List<T> initialValue,
      @required List<Widget> Function(T) displayBuilder,
      @required Widget title,
      @required String addNewItemText,
      @required void Function() onAddNewItem,
      bool autovalidate = false})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue ?? [],
            autovalidate: autovalidate,
            builder: (FormFieldState<List<T>> state) {
              return Column(
                children: [
                  Container(
                    child: title,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  ...state.value
                      .map((Identifiable e) => ChosenItemDisplay<T>(
                            item: e,
                            index: state.value.indexOf(e),
                            length: state.value.length,
                            displayBuilder: displayBuilder,
                            onDelete: () {
                              state.didChange(state.value
                                  .where((Identifiable element) =>
                                      element.id != e.id)
                                  .toList());
                            },
                            onPositionChanged: (change) {
                              if (change == PositionChange.up) {
                                //["asd", "dasdd"]
                                int index = state.value.indexOf(e);
                                int indexBefore = index - 1;

                                if (indexBefore < 0) {
                                  return;
                                }
                                T itemBefore = state.value[indexBefore];
                                state.value[indexBefore] = e;
                                state.value[index] = itemBefore;
                                state.didChange(state.value);
                              }
                              if (change == PositionChange.down) {
                                int index = state.value.indexOf(e);
                                int indexAfter = index + 1;

                                if (indexAfter > state.value.length - 1) {
                                  return;
                                }
                                T itemAfter = state.value[indexAfter];
                                state.value[indexAfter] = e;
                                state.value[index] = itemAfter;
                                state.didChange(state.value);
                              }
                            },
                          ))
                      .toList(),
                  AddNewItemButton(
                    onTap: onAddNewItem,
                    title: addNewItemText,
                  )
                ],
              );
            });
}
