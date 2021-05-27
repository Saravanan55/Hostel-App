import 'package:flutter/material.dart';
import 'database.dart';
import 'validate.dart';
import 'customform_field.dart';

class EditItemForm extends StatefulWidget {
  final FocusNode dateFocusNode;
  final FocusNode breakfastFocusNode;
  final FocusNode lunchFocusNode;
  final FocusNode dinnerFocusNode;
  final String currentDate;
  final String currentBreakfast;
  final String currentLunch;
  final String currentDinner;
  final String documentId;

  const EditItemForm({
    this.dateFocusNode,
    this.breakfastFocusNode,
    this.lunchFocusNode,
    this.dinnerFocusNode,
    this.documentId,
    this.currentDate,
    this.currentBreakfast,
    this.currentLunch,
    this.currentDinner,
  });

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  final _editItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  TextEditingController _dateController;
  TextEditingController _breakfastController;
  TextEditingController _lunchController;
  TextEditingController _dinnerController;

  @override
  void initState() {
    _dateController = TextEditingController(
      text: widget.currentDate,
    );

    _breakfastController = TextEditingController(
      text: widget.currentBreakfast,
    );
    _lunchController = TextEditingController(
      text: widget.currentLunch,
    );
    _dinnerController = TextEditingController(
      text: widget.currentDinner,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _editItemFormKey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.0),
                Text(
                  'Date',
                  style: TextStyle(
                    color: Color(0xFF2C384A),
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _dateController,
                  focusNode: widget.dateFocusNode,
                  keyboardType: TextInputType.datetime,
                  inputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'Date',
                  hint: 'Enter the Date',
                ),
                SizedBox(height: 24.0),
                Text(
                  'Break fast',
                  style: TextStyle(
                    color: Color(0xFF2C384A),
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _breakfastController,
                  focusNode: widget.breakfastFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'Break fast',
                  hint: 'Enter the break fast',
                ),
                SizedBox(height: 24.0),
                Text(
                  'Lunch',
                  style: TextStyle(
                    color: Color(0xFF2C384A),
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _lunchController,
                  focusNode: widget.lunchFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'Lunch',
                  hint: 'Enter the Lunch',
                ),
                SizedBox(height: 24.0),
                Text(
                  'Dinner',
                  style: TextStyle(
                    color: Color(0xFF2C384A),
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _dinnerController,
                  focusNode: widget.dinnerFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'Dinner',
                  hint: 'Enter the Dinner',
                ),
              ],
            ),
          ),
          _isProcessing
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFF57C00),
                    ),
                  ),
                )
              : Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff028090)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      widget.dateFocusNode.unfocus();
                      widget.breakfastFocusNode.unfocus();
                      widget.lunchFocusNode.unfocus();
                      widget.dinnerFocusNode.unfocus();

                      if (_editItemFormKey.currentState.validate()) {
                        setState(() {
                          _isProcessing = true;
                        });

                        await Database.updateItem(
                          docId: widget.documentId,
                          date: _dateController.text,
                          breakfast: _breakfastController.text,
                          lunch: _lunchController.text,
                          dinner: _dinnerController.text,
                        );

                        setState(() {
                          _isProcessing = false;
                        });

                        Navigator.of(context).pop();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text(
                        'UPDATE ITEM',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFECEFF1),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
