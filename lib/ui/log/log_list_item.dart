import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_routes.dart';
import 'package:puftel/db/bloc/log_bloc.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/db/models/log_model.dart';
import 'package:puftel/db/models/medicine_model.dart';
import 'package:puftel/ui/reusables/widget_primary_button.dart';
class LogListItem extends StatelessWidget {

  LogListItem({
    required this.item,
    this.todaysTotal
  });

  LogModel item;
  int? todaysTotal;


  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
          onTap: () {

          },
          child:  Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(color: AppColors.appPrimaryColorGrey),
            child: Row(
              children: [
                Expanded(
                    flex: 75,
                    child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat("d MMM yyyy HH:mm").format(DateTime.fromMillisecondsSinceEpoch(item.dateTime)), style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal)),
                    AppDimensions.verticalSmallSpacer,
                    Text(item.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                  ],
                ),
                ),
                Expanded(
                flex: 25,
                child: Align(
                  alignment: Alignment.centerRight,
                  child:  Text(item.value<=0? item.value.toString() : "+${item.value}",
                      style: TextStyle(
                          fontSize: 32,
                          color: AppColors.appPrimaryColorGreyDarker,
                          fontWeight: FontWeight.bold))
                )
              ),
              ],
            )
          )
      ),
    );
  }
}