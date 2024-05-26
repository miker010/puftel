import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';

class WidgetTextField extends StatefulWidget {
  WidgetTextField({
    required this.labelText,
    required this.textInputType,
    required this.hasObscuredTextInput,
    required this.validator,
    required this.onSaved,
    required this.onChanged,
    this.maxLength = 150,
    this.initialValue,
    this.value,
    this.lineCount = 1
  });

  final bool hasObscuredTextInput;
  final String labelText;
  final TextInputType textInputType;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String> onChanged;
  final int maxLength;
  final String? initialValue;
  final String? value;
  final int lineCount;
  final TextEditingController controller = TextEditingController();

  _WidgetTextFieldState createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<WidgetTextField>{

  @override
  Widget build(BuildContext context) {

    widget.controller.text = widget.initialValue ?? "";

    return TextFormField(
      controller: widget.controller,
      autocorrect: false,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      maxLength: widget.maxLength,
      // initialValue: widget.initialValue ?? "",
      obscureText: widget.hasObscuredTextInput,
      maxLines: widget.lineCount,


      style : TextStyle(
          fontSize: AppDimensions.fontSizeLarge,
          color: AppColors.appPrimaryColorBlack,
          letterSpacing: AppDimensions.letterSpacing
      ),

      decoration: InputDecoration(
          fillColor: AppColors.appPrimaryColorGrey,
          counterText: widget.lineCount == 1? "": null,
          filled: true,
          hintText: widget.labelText,
          focusColor: AppColors.appPrimaryColorBlueDarker,
          labelStyle: TextStyle (color: AppColors.appPrimaryColorBlueDarker),
          errorStyle: TextStyle (fontSize: AppDimensions.fontSizeLarge, color: AppColors.appPrimaryColorRed),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.appPrimaryColorWhite)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.appPrimaryColorWhite))
      ),

      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
    );
  }
}