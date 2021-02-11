import 'package:flutter/material.dart';
import 'package:workout_tracker/config/colors.dart';

class AddNewItemButton extends StatelessWidget {
  final void Function() onTap;

  final String title;

  const AddNewItemButton({
    Key key,
    @required this.onTap,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: EdgeInsets.only(left: 18, right: 18, top: 10),
          decoration: BoxDecoration(
              border: Border.all(color: redColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: InkWell(
            highlightColor: Color.fromARGB(15, 153, 0, 0),
            hoverColor: Color.fromARGB(15, 153, 0, 0),
            splashColor: Color.fromARGB(15, 153, 0, 0),
            customBorder: Border.all(
              width: 10,
            ),
            onTap: onTap,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
