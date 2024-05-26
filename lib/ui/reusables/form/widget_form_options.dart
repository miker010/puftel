import 'package:intl/intl.dart';
import 'package:puftel/ui/reusables/form/widget_form_field_option.dart';

class WidgetFormOptions{

  List<WidgetFormFieldOption> fields;

  WidgetFormOptions({
    required this.fields
  });


  String? getFieldStringValueByName(String fieldName){
    return byFieldName(fieldName).value;
  }

  bool? getFieldBoolValueByName(String fieldName){
    var field = byFieldName(fieldName);
    if (field==null) { return null;}
    if (field.value == "") { return null;}
    var value = int.parse(field.value ?? "0");
    return  (value == 1);
  }

  DateTime? getFieldDateValueByName(String fieldName){
    var field = byFieldName(fieldName);
    if (field.value == null){ return null;}
    try {
      return DateFormat('ddd-MM-yyyy').parse(field.value!);
    }
    catch (e){
      return null;
    }
  }

  int? getFieldIntValueByName(String fieldName){
    var field = byFieldName(fieldName);
    if (field.value == null){ return null;}
    if (field.value == "") { return null;}
    var value = int.parse(field.value ?? "0");
    return  value ;
  }

  WidgetFormFieldOption byFieldName(String fieldName){
    return fields.firstWhere((element) => element.fieldName == fieldName);
  }
}