import 'package:flutter/material.dart';
import 'package:workout_tracker/config/colors.dart';

class ChosenItemDisplay<T> extends StatelessWidget {
  final void Function() onDelete;

  final void Function(PositionChange change) onPositionChanged;

  final List<Widget> Function(T item) displayBuilder;

  final T item;

  final int index;

  final int length;

  const ChosenItemDisplay(
      {Key key,
      this.onDelete,
      this.onPositionChanged,
      @required this.item,
      @required this.index,
      @required this.length,
      @required this.displayBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          children: [
            ...displayBuilder(item),
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      if (index != 0)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_upward,
                            color: brightColor,
                          ),
                          onPressed: () {
                            if (onPositionChanged != null) {
                              onPositionChanged(PositionChange.up);
                            }
                          },
                        ),
                      if (index != length - 1)
                        IconButton(
                            icon: Icon(
                              Icons.arrow_downward,
                              color: brightColor,
                            ),
                            onPressed: () {
                              if (onPositionChanged != null) {
                                onPositionChanged(PositionChange.down);
                              }
                            })
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                        onPressed: onDelete,
                        child: Text(
                          "Törlés",
                          style: TextStyle(
                            color: brightColor,
                          ),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
        color: Colors.white,
        shadowColor: redColor,
      ),
    );
  }
}

enum PositionChange { up, down }
