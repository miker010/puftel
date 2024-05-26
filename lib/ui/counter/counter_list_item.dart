import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:logger/logger.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_routes.dart';
import 'package:puftel/db/bloc/log_bloc.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/db/models/log_model.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/log/log_list_view.dart';
import 'package:puftel/ui/reusables/widget_primary_button.dart';
import 'package:vibration/vibration.dart';

import 'counter_detail_view.dart';

typedef void OnCounterClick(int id, int increment);
typedef void OnDetailsRequest(CounterModel model);

class CounterListItem extends StatefulWidget {

  CounterListItem({
    required this.item,
    required this.onCounterClick,
    required this.onDetailsRequest,
    this.canSelect = true,
    this.badgeColor = AppColors.appPrimaryColorGreen
  });

  CounterModel item;
  LogModel? lastLog;
  int? todayCount;
  bool canSelect;
  Color badgeColor;
  OnCounterClick onCounterClick;
  OnDetailsRequest onDetailsRequest;

  @override
  _CounterListItemState createState() => _CounterListItemState();
}

class _CounterListItemState extends State<CounterListItem> {

  var logBloc = LogBloc();

  _fetchTodayCount() async {
    final todayCount = await logBloc.getTodaysTotal(widget.item.id);
    if (todayCount != null){
      if (mounted){
        setState(() {
          widget.todayCount = todayCount;
        });
      }
    }
  }

  _fetchLastLog() async {
    final lastLog = await logBloc.getLast(counterId: widget.item.id);
    if (lastLog != null){
      if (mounted){
        setState(() {
          widget.lastLog = lastLog;
        });
      }
    }
  }

  _incrementCounter(CounterModel model, int increment){
    widget.onCounterClick.call(model.id,increment);
    logBloc.addEntry("${model.name} ${MyApp.local.counter_item_increased_with} ${increment}", increment, model.id);
  }

  _navToDetails (BuildContext context, CounterModel model){
    widget.onDetailsRequest(model);
  }

  String _getFriendlyDate(int date){

    final dateCompare = DateTime.fromMillisecondsSinceEpoch(date);
    final dateNow = DateTime.now();

    if (dateCompare.year == dateNow.year &&
        dateCompare.month == dateNow.month &&
        dateCompare.day == dateNow.day){

      return MyApp.local.today + " " +
          DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(date));
    }

    return DateFormat("d MMM yyyy HH:mm").
      format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width - (5*AppDimensions.paddingMedium);

    if (widget.lastLog == null){
      _fetchLastLog();
    }

    if (widget.todayCount==null){
      _fetchTodayCount();
    }

    final item = widget.item;

    return Material(
      child: InkWell(
        onTap: (){
          Logger().d("on tap counter ${item.name}");
          _navToDetails(context,item);
        },
        child:   Container(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
             // color: AppColors.appPrimaryColorWhite,
              border: Border.all(color: AppColors.getColor(item.color ?? 0)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),

            child:
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Container(
                            padding: EdgeInsets.all(AppDimensions.paddingSmall),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: AppColors.getColor(item.color ?? 0),
                                  shape: BoxShape.circle
                              ),
                            )
                        )
                    ),
                    Expanded(
                        flex: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style:
                            TextStyle(
                                color: AppColors.appPrimaryColorBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.normal)),
                          ],
                        )),
                    Expanded(
                        flex: 20,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(item.value.toString(),
                            style: TextStyle(
                                color: (item.value < item.warningAtCount)? AppColors.appPrimaryColorBlack :
                                (item.value < item.maxCount)? AppColors.appPrimaryColorOrange :
                                AppColors.appPrimaryColorRed,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),),
                        )
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth, // Neem de hele breedte in beslag
                      //padding: EdgeInsets.only(left: AppDimensions.paddingSmall),
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.appPrimaryColorGreyLight, // Grijze achtergrondkleur
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.getColor(item.color)),
                        value: 1-(item.value/item.maxCount),
                        // Rode voortgangskleur
                        minHeight: 4.0, // Hoogte van de balk
                      ),
                    ),
                  ],
                ),
                AppDimensions.verticalSmallSpacer,
                Row(
                  children: [
                    (widget.todayCount == null)? Text("") :
                    Text(
                        "${MyApp.local.today_counted} ${widget.todayCount}",
                        style: TextStyle(fontSize: 12, color: AppColors.appPrimaryColorGreyDarker)),

                  ],
                ),
                Row(
                  children: [
                    widget.lastLog == null?
                    Text(" ", style: TextStyle(fontSize: 12),):
                    Text("${MyApp.local.today_last} ${_getFriendlyDate(widget.lastLog!.dateTime)}", // +${widget.lastLog?.value}
                        style: TextStyle(fontSize: 12, color: AppColors.appPrimaryColorGreyDarker)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex:80,
                      child: Row(
                        children: [
                          WidgetPrimaryButton(labelText: "+1",
                              fillColor: AppColors.getColor(item.color),
                              splashColor: AppColors.getColor(item.color),
                              onClicked: (){
                                _incrementCounter(item, 1);
                                HapticFeedback.mediumImpact();
                              }),
                          AppDimensions.horizontalSmallSpacer,
                          WidgetPrimaryButton(labelText: "+4",
                              fillColor: AppColors.getColor(item.color),
                              splashColor: AppColors.getColor(item.color),
                              onClicked: (){
                                _incrementCounter(item, 4);
                                HapticFeedback.heavyImpact();
                              }),
                          AppDimensions.horizontalSmallSpacer,
                          WidgetPrimaryButton(labelText: " ",
                              leadingIcon: Icon(Icons.view_agenda_outlined, color: AppColors.appPrimaryColorWhite,),
                              fillColor: AppColors.getColor(item.color),
                              splashColor: AppColors.getColor(item.color),
                              onClicked: (){
                                Navigator.pushNamed(context, AppRoutes.logList,
                                    arguments: LogListArguments(counterid: item.id));
                                }
                              ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 20,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Material(
                              child: InkWell(
                                  onTap: (){
                                    _navToDetails(context,item);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(AppDimensions.paddingSmall),
                                      child: Icon(Icons.mode_edit_sharp, color: AppColors.appPrimaryColor, size: 16)
                                  )
                              ),
                            )
                        )
                    ),
                    /*
               ,*/
                  ],
                )
              ],
            )
        )
      ),
    );
  }
}