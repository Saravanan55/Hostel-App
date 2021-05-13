import 'package:flutter/material.dart';
import 'package:hostel/ui/UserDashboard.dart';
import 'package:hostel/ui/outpass_form.dart';
import 'dart:math' as math;

class ProductFABLeave extends StatefulWidget {
  @override
  _ProductFABLeaveState createState() => _ProductFABLeaveState();
}

class _ProductFABLeaveState extends State<ProductFABLeave>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'outpass',
              tooltip: 'Add a Complaint',
              mini: true,
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => UserDashboard()));
              },
              child: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 0.5, curve: Curves.easeOut)),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'leave',
              tooltip: 'Add a Complaint',
              mini: true,
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new OutpassForm()));
              },
              child: Icon(Icons.create, color: Colors.blue),
            ),
          ),
        ),
        FloatingActionButton(
          heroTag: 'options',
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                child: Icon(
                    _controller.isDismissed ? Icons.more_vert : Icons.close),
              );
            },
          ),
        ),
      ],
    );
  }
}
