import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';

class DrawerNavigation extends StatefulWidget {
  final Widget child;
  final double? radius;
  DrawerNavigation(
      {Key? key,
        required this.child,
        this.radius = 0
      })
      : super(key: key);

  @override
  DrawerNavigationState createState() => DrawerNavigationState();
}

class DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors.transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: Drawer(
          elevation: 20.0,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(widget.radius!), bottomRight: Radius.circular(widget.radius!)),
              ),
              child: widget.child
          ),
        )
    );
  }
}
