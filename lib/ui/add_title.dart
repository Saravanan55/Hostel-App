import 'package:flutter/material.dart';
import 'colors.dart';

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 8),
        Text(
          'Food Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        )
        // Text(
        //   ' CRUD',
        //   style: TextStyle(
        //     color: CustomColors.firebaseOrange,
        //     fontSize: 18,
        //   ),
        // ),
      ],
    );
  }
}
