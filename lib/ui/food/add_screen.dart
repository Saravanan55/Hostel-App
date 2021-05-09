import 'package:flutter/material.dart';
import 'add_item.dart';
import 'colors.dart';
//import 'package:flutterfire_samples/widgets/add_item_form.dart';
import 'add_title.dart';

class AddScreen extends StatelessWidget {
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _breakfastFocusNode = FocusNode();
  final FocusNode _lunchFocusNode = FocusNode();
  final FocusNode _dinnerFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dateFocusNode.unfocus();
        _breakfastFocusNode.unfocus();
        _lunchFocusNode.unfocus();
        _dinnerFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff028090),
          title: AppBarTitle(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: AddItemForm(
              dateFocusNode: _dateFocusNode,
              breakfastFocusNode: _breakfastFocusNode,
              lunchFocusNode: _lunchFocusNode,
              dinnerFocusNode: _dinnerFocusNode,
            ),
          ),
        ),
      ),
    );
  }
}
