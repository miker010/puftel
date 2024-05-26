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
import 'package:puftel/db/models/today_model.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/log/log_list_view.dart';
import 'package:puftel/ui/reusables/widget_primary_button.dart';
import 'package:collection/collection.dart';

import 'aggregate_item.dart';

class TodayListItem extends StatefulWidget {

  TodayListItem({
    required this.item,
    this.logs
  });

  TodayModel item;
  List<LogModel>? logs;

  @override
  _TodayListItemState createState() => _TodayListItemState();
}

class _TodayListItemState extends State<TodayListItem> {

  var logBloc = LogBloc();

  List<AggregateItem> _combineLog(TodayModel item){

    List<AggregateItem> result = [];

    if (widget.logs==null){
      return result;
    }

    var counterLogs = widget.logs?.where((element) =>
    element.counterId == item.id && element.value != 0);

    counterLogs?.forEach((log) {
       final date = DateTime.fromMillisecondsSinceEpoch(log.dateTime+600000);
       final h = date.hour;

       var entry = result.firstWhereOrNull((element) => element.label == h.toString().padLeft(2, '0'));
       if (entry==null){
         result.add(AggregateItem(label: h.toString().padLeft(2, '0'), value: log.value));
       }
       else {
         entry.value = entry.value + log.value;
       }
    });

    result.sortBy((element) => element.label);
    return result;
  }

  _getLog(int id) async {
    Navigator.pushNamed(context, AppRoutes.logList,
        arguments: LogListArguments(counterid: id));
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width - (5*AppDimensions.paddingMedium);

    final item = widget.item;

    var counterLogs = _combineLog(item);

    return Material(
      child: InkWell(
          onTap: (){
              _getLog(item.id);
          },
          child:   Container(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                // color: AppColors.appPrimaryColorWhite,
                border: Border.all(color: AppColors.appPrimaryColorGreyDark),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),

              child:
              Column(
                children: [
                    Row(
                      children: [
                        Expanded(
                          flex:60,
                          child: Row(
                            children: [
                                Text(widget.item.name, style: TextStyle(
                                    fontSize: AppDimensions.fontSizeMedium,
                                    fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Expanded(
                          flex:20,
                          child: Row(
                            children: [
                              Text("${widget.item.value.toString()}x",
                                  style: TextStyle(
                                      fontSize: AppDimensions.fontSizeMedium,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ],
                    ),
                    (counterLogs== null)?
                        Container():
                        Column(
                          children: [
                            for (var log in counterLogs!)
                            Row(
                              children: [
                                Text(log.label),
                                AppDimensions.horizontalMediumSpacer,
                                Text("+${log.value}")
                              ],
                            )
                        ],
                      )
                ],
              )
          )
      ),
    );
  }
}