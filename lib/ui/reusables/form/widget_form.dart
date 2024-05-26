import 'package:flutter/material.dart';
import 'package:puftel/ui/reusables/form/widget_form_field_option.dart';
import 'package:puftel/ui/reusables/form/widget_form_options.dart';
import 'widget_text_field.dart';

class WidgetForm extends StatefulWidget {
  WidgetForm({
    required this.formOptions
  });

  final WidgetFormOptions formOptions;
  String value = "";

  _WidgetFormState createState() => _WidgetFormState();
}

class _WidgetFormState extends State<WidgetForm>{

  Widget _buildField (BuildContext context, WidgetFormFieldOption field) {
      return _buildTextField(context, field);

  }

  Widget _buildTextField (BuildContext context, WidgetFormFieldOption field) {

    var defaultValidator = (String? value) {
      return value!.length < field.minLength ? "" : null;
    };

    var emailValidator = (String? value) {
      if (value==null) {return null;}
      if (value.trim().isEmpty) {
        return 'Please enter your email address';
      }
      // Check if the entered email has the right format
      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
      // Return null if the entered email is valid
      return null;
    };

    var zipCodeValidator = (String? value) {
      return value!.length < field.minLength ? "" : null;
    };

    var validator = defaultValidator;
    if (field.textInputType == TextInputType.emailAddress){
      validator = emailValidator;
    }

    final textField = WidgetTextField(
      labelText: field.placeHolder,
      initialValue: field.value,
      textInputType: field.textInputType,
      hasObscuredTextInput: false,
      validator: validator,
      maxLength: field.maxLength,
      lineCount: field.lineCount,
      onSaved: (val) => print("test"),
      onChanged: (String? newValue) {  field.value = newValue; },);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (field.labelText.length>0)? Text("${field.labelText}") : Container(),
          SizedBox(height: 8.0),

          field.hasButton?
          Row(
            children: [
              Expanded(
                  flex: 75,
                  child: textField
              ),
              Expanded(
                  flex: 25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(30, 55),
                        primary: field.buttonColor
                    ),
                    onPressed: () {
                      if (field.onButtonClicked != null) {
                        field.onButtonClicked!("");
                      }
                    },
                    child: Text("${field.buttonText}"),
                  )
              ),
            ],
          ) : Container(),
          !field.hasButton? textField : Container(),
          SizedBox(height: 8.0),
          (field.hasDivider)? Divider() : Container()
        ]
    );
  }

  Widget _buildForm(BuildContext context){

    final _formKey = GlobalKey<FormState>();

    return Form(key: _formKey,
      child: Column(
        children: <Widget>[
          for (var field in widget.formOptions.fields)
            _buildField(context, field)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildForm(context),
    );
  }
}