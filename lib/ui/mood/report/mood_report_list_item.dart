import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/db/bloc/log_bloc.dart';
import 'package:puftel/db/models/mood_model.dart';
import 'package:puftel/main.dart';

class MoodReportListItem extends StatefulWidget {

  MoodReportListItem({
    required this.item
  });

  MoodModel item;

  @override
  _MoodReportListItemState createState() => _MoodReportListItemState();
}

class _MoodReportListItemState extends State<MoodReportListItem> {
  var logBloc = LogBloc();

  bool _isToday (DateTime date){
    final dateCompare = date;
    final dateNow = DateTime.now();

    if (dateCompare.year == dateNow.year &&
        dateCompare.month == dateNow.month &&
        dateCompare.day == dateNow.day){
      return true;
    }

    return false;
  }

  String _getFriendlyDate(DateTime date){
    final dateCompare = date;
    final dateNow = DateTime.now();

    if (dateCompare.year == dateNow.year &&
        dateCompare.month == dateNow.month &&
        dateCompare.day == dateNow.day){
      return MyApp.local.today;
    }

    return DateFormat("d MMM yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    DateTime _getDateFromInt(int value){
      final strValue = value.toString();

      if (strValue.toString().length<8){
        return DateTime.now();
      }

      final year = strValue.substring(0,4);
      final month = strValue.substring(4,6);
      final day = strValue.substring(6,8);

      var result =  DateTime(int.parse(year), int.parse(month), int.parse(day));
      return result;
    }

    return Material(
      child: InkWell(
          onTap: (){
              //TODO: In future we want to be able to move from mood to log report
          },
          child:   Container(
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  (widget.item.value==0)?
                    Image.asset(
                      "assets/sad.png",
                      width: 32 ,
                      color: AppColors.appPrimaryColorRed)
                  :
                    (widget.item.value==1)?
                      Image.asset(
                          "assets/mweh.png",
                          width: 32,
                          color: AppColors.appPrimaryColorOrange)
                    :
                    Image.asset(
                        "assets/ok.png",
                        width: 32,
                        color: AppColors.appPrimaryColorGreen),
                  AppDimensions.horizontalMediumSpacer,
                  Text(_getFriendlyDate(_getDateFromInt(widget.item.dateTime)),
                  style: TextStyle(fontWeight:
                    (_isToday(_getDateFromInt(widget.item.dateTime))?
                      FontWeight.bold: FontWeight.normal
                    )
                  )
                  )
                ],
              )
          )
      ),
    );
  }
}