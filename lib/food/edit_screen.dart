import 'package:flutter/material.dart';
import 'database.dart';
import 'edit_item.dart';

class EditScreen extends StatefulWidget {
  final String currentdate;
  final String currentbreakfast;
  final String currentlunch;
  final String currentdinner;
  final String documentId;

  EditScreen({
    this.documentId,
    this.currentdate,
    this.currentbreakfast,
    this.currentlunch,
    this.currentdinner,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _breakfastFocusNode = FocusNode();
  final FocusNode _lunchFocusNode = FocusNode();
  final FocusNode _dinnerFocusNode = FocusNode();

  bool _isDeleting = false;

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
          title: Text("Food", style: TextStyle(color: Colors.white)),
          actions: [
            _isDeleting
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      right: 16.0,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.redAccent,
                      ),
                      strokeWidth: 3,
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 32,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isDeleting = true;
                      });

                      await Database.deleteItem(
                        docId: widget.documentId,
                      );

                      setState(() {
                        _isDeleting = false;
                      });

                      Navigator.of(context).pop();
                    },
                  ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: EditItemForm(
              documentId: widget.documentId,
              dateFocusNode: _dateFocusNode,
              breakfastFocusNode: _breakfastFocusNode,
              lunchFocusNode: _lunchFocusNode,
              dinnerFocusNode: _dinnerFocusNode,
              currentDate: widget.currentdate,
              currentBreakfast: widget.currentbreakfast,
              currentLunch: widget.currentlunch,
              currentDinner: widget.currentdinner,
            ),
          ),
        ),
      ),
    );
  }
}
