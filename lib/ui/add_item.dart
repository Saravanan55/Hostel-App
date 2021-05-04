import 'package:flutter/material.dart';
import 'colors.dart';
import 'database.dart';
import 'validate.dart';
import 'customform_field.dart';

class AddItemForm extends StatefulWidget {
  final FocusNode dateFocusNode;
  final FocusNode breakfastFocusNode;
  final FocusNode lunchFocusNode;
  final FocusNode dinnerFocusNode;
  const AddItemForm({
    this.dateFocusNode,
    this.breakfastFocusNode,
    this.lunchFocusNode,
    this.dinnerFocusNode,
  });

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _addItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _mrngController = TextEditingController();
  final TextEditingController _afternoonController = TextEditingController();
  final TextEditingController _nightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addItemFormKey,
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
                  'Title',
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
                  controller: _mrngController,
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
                  controller: _afternoonController,
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
                  controller: _nightController,
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
                      CustomColors.firebaseOrange,
                    ),
                  ),
                )
              : Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        CustomColors.firebaseOrange,
                      ),
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

                      if (_addItemFormKey.currentState.validate()) {
                        setState(() {
                          _isProcessing = true;
                        });

                        await Database.addItem(
                          date: _dateController.text,
                          breakfast: _mrngController.text,
                          lunch: _afternoonController.text,
                          dinner: _nightController.text,
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
                        'ADD ITEM',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.firebaseGrey,
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
