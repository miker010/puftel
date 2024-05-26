import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_messages.dart';
import 'package:puftel/app/app_routes.dart';
import 'package:puftel/db/bloc/counter_bloc.dart';
import 'package:puftel/db/bloc/log_bloc.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/log/log_list_view.dart';
import 'package:puftel/ui/reusables/widget_button_nav_bart.dart';
import 'package:puftel/ui/reusables/widget_primary_button.dart';
import 'package:puftel/ui/reusables/widget_text_field.dart';
import 'package:vibration/vibration.dart';

class CounterDetailsArguments {
  final CounterModel model;

  CounterDetailsArguments({
    required this.model});
}

class CounterDetailView extends StatefulWidget{
  CounterDetailView({
    Key? key,
    required this.title}) : super(key: key);

  bool? hasAudio = true;
  bool? hasVideo = true;
  bool? hasConnection = null;

  final String title;

  var warningCount = -1;
  var maxCount = -1;
  CounterModel? model;

  String? editedTitle;
  String? editedDescription;

  @override
  _CounterDetailViewState createState() => _CounterDetailViewState();
}

class _CounterDetailViewState extends State<CounterDetailView> {

  CounterDetailsArguments _getArgs(){
    return ModalRoute.of(context)?.settings.arguments as CounterDetailsArguments;
  }

  var bloc = CounterBloc();
  Timer? maxCountTimer;
  Timer? warningCountTimer;

  CounterModel _getModel(){
    if (widget.model == null) {
      widget.model = _getArgs().model;
    }

    return widget.model!;
  }

  @override
  void initState() {
    super.initState();

   bloc.getIncResult.listen((event) {
     setState(() {
        _getModel().value = event.newValue;
     });

     MyApp.eventBloc.setEvent("ALL", 100, "Warning counter updated");
   });
  }

  _changeMaxCount(CounterModel model, int value)  {
    widget.maxCount = value;
  }

  _setMaxCount(CounterModel model, int value) async {
    await bloc.setMaxCount(model.id,value);
    LogBloc().addEntry("${model.name} ${MyApp.local.counter_detail_max_changed_to} ${value}", 0, model.id);

    Future.delayed(const Duration(milliseconds: 1000), () {
      MyApp.eventBloc.setEvent("ALL", 100, "Max counter updated");
    });
  }

  _changeWarningCount(CounterModel model, int value) {
    widget.warningCount = value;
  }

  _setWarningCount(CounterModel model, int value) async{
    widget.warningCount = value;
    await bloc.setWarningCount(model.id,value);
    LogBloc().addEntry("${model.name} ${MyApp.local.counter_details_warning_changed} ${value}", 0, model.id);

    Future.delayed(const Duration(milliseconds: 1000), () {
      MyApp.eventBloc.setEvent("ALL", 100, "Max counter updated");
    });


  }

  _incrementCounter(CounterModel model, int increment) async {
    await bloc.inc(model.id, increment);
    LogBloc().addEntry("${model.name} ${MyApp.local.counter_details_edited} ${increment}", increment, model.id);
  }

  _getLog(CounterModel model) async {
    Navigator.pushNamed(context, AppRoutes.logList,
        arguments: LogListArguments(counterid: model.id)
    );
  }

  _resetCounter(CounterModel model) async {
    AppMessages.notifyYesNo(context,
        MyApp.local.counter_detail_reset + " ${model.name}",
        "${MyApp.local.counter_detail_reset_description}", () async {
      Vibration.vibrate(
        pattern: [500, 1000],
      );
      await bloc.reset(model.id);
      MyApp.eventBloc.setEvent("ALL", 100, "Warning counter updated");
      LogBloc().addEntry("${model.name} ${MyApp.local.counter_detail_resetted}", 0, model.id);

      Navigator.of(context).pop();

    });
  }

  _delete(CounterModel model) {

    AppMessages.notifyYesNo(context, MyApp.local.counter_detail_delete + " ${model.name}", MyApp.local.counter_detail_delete_description, () async {
      await bloc.delete(model.id);
      MyApp.eventBloc.setEvent("ALL", 100, "Warning counter deleted");
      LogBloc().addEntry("${model.name} ${MyApp.local.counter_details_deleted}", 0, model.id);
      Navigator.of(context).pop();
    });
  }

  @override
  dispose() {

    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return _buildView();
  }



  _selectColor (int id, int colorIndex){

    bloc.setColor(id, colorIndex);

    setState(() {
      widget.model?.color = colorIndex;
    });

    Navigator.of(context).pop();
    MyApp.eventBloc.setEvent("ALL", 100, "Color changed");
  }


  Widget _getPickColor(BuildContext context, int id, int colorIndex){
    
    return   Expanded(
      flex: 3,
      child: Material(
        child: InkWell(
            onTap: (){
              _selectColor(id, colorIndex);
            },
            child: Container(
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.getColor(colorIndex),
                    shape: BoxShape.circle
                ),
              )
            )
        ),
      ),
    );
  }

  _pickColor(BuildContext context, int id){
    showDialog(
      context: context, barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(MyApp.local.counter_detail_pick_color),
          content: new SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(color: AppColors.appPrimaryColorWhite),
              child: Column(
                children: [
                  Row(
                    children: [
                      _getPickColor(context, id, 0),
                      _getPickColor(context, id,1),
                      _getPickColor(context, id,2)
                    ],
                  ),
                  AppDimensions.verticalMediumSpacer,
                  Row(
                    children: [
                      _getPickColor(context, id,3),
                      _getPickColor(context, id,4),
                      _getPickColor(context, id,5)
                    ],
                  ),
                  AppDimensions.verticalMediumSpacer,
                  Row(
                    children: [
                      _getPickColor(context, id,6),
                      _getPickColor(context, id,7),
                      _getPickColor(context, id,8)
                    ],
                  )
                ],
              )
            )

        )
        );
      },
    );
  }

  _applyTextChanges(){
      if (widget.editedTitle != null && widget.editedDescription != null){
          bloc.setTexts(widget.model?.id ?? 0, widget.editedTitle ?? "", widget.editedDescription ?? "");

          setState(() {
            widget.model?.name = widget.editedTitle ?? "";
            widget.model?.description = widget.editedDescription ?? "";

          });

          MyApp.eventBloc.setEvent("ALL", 100, "Color changed");
      }

      Navigator.of(context).pop();
      setState(() {
      });
  }

  _editText() {

    _getModel();

    var titleField =  WidgetTextField(labelText: MyApp.local.counter_detail_title,
        textInputType: TextInputType.text,
        hasObscuredTextInput: false,
        initialValue: widget.model?.name ?? "" ,
        validator: (String? value) {
          return value!.length < 0 ? "" : null;
        },
        onSaved: (value) {

        },
        onChanged: (value) {
          widget.editedTitle = value;
          widget.model?.name = value ?? "";
        }
    );

    var descriptionField = WidgetTextField(labelText: MyApp.local.counter_detail_description,
        textInputType: TextInputType.text,
        hasObscuredTextInput: false,
        initialValue: widget.model?.description ?? "",
        maxLength: 1000,
        lineCount: 3,
        validator: (String? value) {
          return value!.length < 0 ? "" : null;
        },
        onSaved: (value) {

        },
        onChanged: (value) {
          widget.editedDescription = value;
          widget.model?.description = value ?? "";
        }
    );

    titleField.controller.text = widget.model?.name ?? MyApp.local.counter_detail_no_name;
    descriptionField.controller.text = widget.model?.description ?? MyApp.local.counter_detail_no_description;

    widget.editedTitle = widget.model?.name ?? "";
    widget.editedDescription = widget.model?.description ?? "";

    showDialog(
      context: context, barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: AppColors.getColor(widget.model?.color ?? 0),
            title: null,
            content: new SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppDimensions.paddingSmall),
                    decoration: BoxDecoration(color: AppColors.appPrimaryColorWhite),
                    child: Column(
                      children: [
                        titleField,
                        descriptionField,
                        WidgetPrimaryButton(labelText: MyApp.local.counter_detail_save,
                            fillColor: AppColors.getColor(widget.model?.color ?? 0),
                            splashColor:  AppColors.getColor(widget.model?.color ?? 0),
                            onClicked: (){
                            _applyTextChanges();
                        })
                      ],
                    )
                )

            )
        );
      },
    );
  }

  Widget _buildView() {
    final args = _getArgs();

    if (widget.maxCount<0) {
      widget.maxCount = args.model.maxCount;
      widget.warningCount = args.model.warningAtCount;
    }

    _getModel();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        iconTheme: IconThemeData(
          color: AppColors.appPrimaryColorWhite, //change your color here
        ),
        title: Text(widget.title, style: TextStyle(color: AppColors.appPrimaryColorWhite),),
        actions: [
          WidgetButtonNavBar(
            icon: Icons.delete_rounded,
            onClicked: () {
              setState(() {
                _delete(args.model);
              });
            }, title: '',
          )
        ],
      ),
      drawer: null,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.appSecondaryColorLight),
          ),

          Container(

              child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(AppDimensions.marginSmall),
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryColorWhite,
                        border: Border.all(color: AppColors.getColor(widget.model?.color ?? 0),),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 10,
                                            child: Material(
                                              child: InkWell(
                                                onTap: (){
                                                  _pickColor(context, widget.model?.id ?? 0);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(AppDimensions.paddingSmall),
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,

                                                    decoration: BoxDecoration(
                                                        color: AppColors.getColor(widget.model?.color ?? 0),
                                                        shape: BoxShape.circle
                                                    ),
                                                  )
                                                )
                                            ),
                                            )
                                          ),
                                        Expanded(
                                            flex: 80,
                                            child: Text(_getModel().name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),),
                                        Expanded(
                                          flex: 10,
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {
                                                _editText();
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(AppDimensions.paddingSmall),
                                                  child: Icon(Icons.edit, size: 20,)
                                              ),
                                            ),
                                          ),
                                        )

                                      ],
                                    ),

                                    AppDimensions.verticalSmallSpacer,
                                    Text(_getModel().description, style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                                    AppDimensions.verticalSmallSpacer,


                                    Divider(),
                                    Text("${MyApp.local.counter_detail_counter_current_value}: ${_getModel().value.toString()}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                    AppDimensions.verticalMediumSpacer,
                                    Row(
                                      children: [
                                        WidgetPrimaryButton(labelText: "",
                                            fillColor: AppColors.getColor(widget.model?.color ?? 0),
                                            splashColor:  AppColors.getColor(widget.model?.color ?? 0),
                                            leadingIcon: Icon(Icons.exposure_minus_1, color: AppColors.appPrimaryColorGrey),
                                            onClicked: (){
                                              _incrementCounter(_getModel(), -1);
                                            }),
                                        AppDimensions.horizontalSmallSpacer,
                                        WidgetPrimaryButton(
                                            fillColor: AppColors.getColor(widget.model?.color ?? 0),
                                            splashColor:  AppColors.getColor(widget.model?.color ?? 0),
                                            leadingIcon: Icon(Icons.restart_alt_rounded, color: AppColors.appPrimaryColorGrey),
                                            labelText: "", onClicked: (){
                                          _resetCounter(_getModel());
                                        }),
                                        AppDimensions.horizontalSmallSpacer,
                                        WidgetPrimaryButton(
                                            fillColor: AppColors.getColor(widget.model?.color ?? 0),
                                            splashColor:  AppColors.getColor(widget.model?.color ?? 0),
                                            leadingIcon: Icon(Icons.view_agenda_outlined, color: AppColors.appPrimaryColorGrey),
                                            labelText: "", onClicked: (){
                                          _getLog(_getModel());
                                        })
                                      ],
                                    ),
                                    AppDimensions.verticalMediumSpacer,
                                    Divider(),
                                    AppDimensions.verticalMediumSpacer,
                                    Row(
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Text(MyApp.local.counter_detail_max),
                                                NumberPicker(
                                                  value: widget.maxCount,
                                                  minValue: 10,
                                                  maxValue: 1000,
                                                  onChanged: (value) => setState(() => _changeMaxCount(_getModel(),value)),
                                                ),
                                              ],
                                            )),
                                        AppDimensions.horizontalMediumSpacer,
                                        Flexible(
                                            flex : 1,
                                            child: Column(
                                              children: [
                                              Text(MyApp.local.counter_detail_warning_at),
                                              NumberPicker(
                                              value: widget.warningCount,
                                              minValue: 10,
                                              maxValue: 1000,
                                              onChanged: (value) => setState(() => _changeWarningCount(_getModel(),value)),
                                              ),
                                              ],
                                              ))
                                      ],
                                    ),
                                    WidgetPrimaryButton(labelText: MyApp.local.counter_detail_edit,
                                        splashColor: AppColors.getColor(widget.model?.color ?? 0),
                                        fillColor: AppColors.getColor(widget.model?.color ?? 0),

                                        onClicked: () async {

                                          if (widget.model != null && widget.warningCount>0) {
                                            await _setWarningCount(
                                                widget.model!, widget.warningCount);
                                          }

                                          if (widget.model != null && widget.maxCount>0) {
                                            await _setMaxCount(
                                                widget.model!, widget.maxCount);
                                          }

                                          Navigator.of(context).pop();


                                    })
                                  ],
                                )
                            )
                          ],
                        ),
                      ],
                    ),
                  )
              )
          )
        ],
      ),
    );
  }
}