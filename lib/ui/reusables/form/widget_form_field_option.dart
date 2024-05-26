import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/ui/reusables/form/specific_input_type.dart';

class WidgetFormFieldOption {
  WidgetFormFieldOption({
    required this.fieldName,
    required this.labelText,
    required this.textInputType,
    this.onChanged,
    this.onSaved,

    this.hasObscuredTextInput = false,
    this.maxLength = 100,
    this.minLength = 0,
    this.placeHolder = "",
    this.value,
    this.hasDivider = false,
    this.lineCount = 1,
    this.hasButton = false,
    this.onButtonClicked,
    this.buttonText = "",
    this.buttonColor =  AppColors.appPrimaryColor,
    this.specificInputType = SpecificInputType.none
  });

  final String fieldName;

  bool hasDivider;
  String? value;
  final String placeHolder;
  final int minLength;
  final int maxLength;
  final int lineCount;
  final bool hasObscuredTextInput;
  final String labelText;
  final TextInputType textInputType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final FormFieldSetter<String>? onButtonClicked;
  final bool hasButton ;
  final String buttonText;
  final Color buttonColor;
  final SpecificInputType specificInputType;

}