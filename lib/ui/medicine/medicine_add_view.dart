import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_storage.dart';
import 'package:puftel/db/app_db_manager.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/db/models/medicine_model.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/reusables/form/widget_form.dart';
import 'package:puftel/ui/reusables/form/widget_form_field_option.dart';
import 'package:puftel/ui/reusables/form/widget_form_options.dart';
import 'package:puftel/ui/reusables/widget_primary_button.dart';

class MedicineAddArguments {
  final MedicineModel model;

  MedicineAddArguments({
    required this.model});
}

class MedicineAddView extends StatefulWidget{
  MedicineAddView({
    Key? key}) : super(key: key);

  @override
  _MedicineAddviewState createState() => _MedicineAddviewState();
}

class _MedicineAddviewState extends State<MedicineAddView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  MedicineAddArguments _getArgs(){
    return ModalRoute.of(context)?.settings.arguments as MedicineAddArguments;
  }

  _addMedicine() async {
    final counterId = await AppStorage.getNewId("counter");
    final medicine = _getArgs().model;

    final counterModel = CounterModel(
        id: counterId,
        name: medicine.name,
        value: 0,
        description: medicine.description,
        maxCount: 200,
        warningAtCount: 160,
        link: medicine.link,
        color: medicine.color
    );

    final manager = AppDBManager();
    await manager.init();
    await manager.insertCounter(counterModel);

    MyApp.eventBloc.setEvent("ALL", 100, "Counter added");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<WidgetFormFieldOption> fields= [];
    fields.add(WidgetFormFieldOption(
        fieldName: "name",
        labelText: "Naam",
        textInputType: TextInputType.text));

    fields.add(WidgetFormFieldOption(
        fieldName: "description",
        labelText: "Beschrijving",
        textInputType: TextInputType.text));

    final formOptions = WidgetFormOptions(fields: fields);
    final medicine = _getArgs().model;

    return Scaffold(
        appBar:  AppBar(
          backgroundColor: AppColors.appPrimaryColor,
          iconTheme: IconThemeData(
            color: AppColors.appPrimaryColorWhite
          ),
          title: Text(medicine.name,
                style: TextStyle(color: AppColors.appPrimaryColorWhite)
          ),
          actions: [],
        ),
        body: Container(
            margin: EdgeInsets.only(top: AppDimensions.marginSmall),
            padding: EdgeInsets.all(AppDimensions.marginSmall),
            child:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetForm(formOptions: formOptions),
                  NumberPicker(
                    value: 200,
                    minValue: 10,
                    maxValue: 1000,
                    onChanged: (value) => setState(() {
                        Logger().d("Number picker value changed to: ${value}");
                    })),

                  WidgetPrimaryButton(labelText: MyApp.local.medicine_list_item_add, onClicked: (){
                    _addMedicine();
                  })
                ]
              ),
            )
        )
    );
  }
}