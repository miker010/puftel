import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/db/bloc/mood_bloc.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/mood/mood_state_enum.dart';

class MoodInputView extends StatefulWidget {

  MoodInputView({
    this.state
  });

  MoodStateEnum? state;

@override
_MoodInputViewState createState() => _MoodInputViewState();
}

class _MoodInputViewState extends State<MoodInputView> {

  var bloc = MoodBloc();

  _changeMoodForToday(MoodStateEnum state){
    Logger().d("Change mood for ${DateTime.now()} to ${state}");
    setState(() {
      //TODO: Mood type id FIXED to 1 for now
      bloc.setTodaysMood(state, 1);
      widget.state = state;
    });
  }

  @override
  void initState() {
    super.initState();



  }

  String _getMoodTitle(){
    if (widget.state == null){
      return MyApp.local.mood_how_is_it_going_today;
    }

    switch(widget.state!){
      case MoodStateEnum.ok: return MyApp.local.mood_how_is_it_going_today_ok;
      case MoodStateEnum.mweh: return MyApp.local.mood_how_is_it_going_today_mweh;
      case MoodStateEnum.sad: return MyApp.local.mood_how_is_it_going_today_sad;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusMedium)),
          border: Border.all(color: AppColors.appPrimaryColorGreyDark),
          color: AppColors.appPrimaryColorGreyLight),
      padding: EdgeInsets.all(AppDimensions.paddingSmall),
      margin: EdgeInsets.only(bottom: AppDimensions.marginMedium),
      child: Column(
        children: [
          Text(_getMoodTitle()),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              child: Row(
                children: [
                  Expanded(
                      flex:33,
                      child: Material(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        color: (widget.state==MoodStateEnum.sad)?
                         AppColors.appPrimaryColorGreyDark:
                         AppColors.appPrimaryColorGreyLight,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            onTap: (){
                              _changeMoodForToday(MoodStateEnum.sad);
                            },
                            child: Container(
                              padding: EdgeInsets.all(AppDimensions.paddingSmall),
                              child: Image.asset("assets/sad.png", width: double.infinity)
                            )
                        ),
                      )
                  ),
                  Expanded(
                      flex:33,
                      child: Material(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        color: (widget.state==MoodStateEnum.mweh)?
                        AppColors.appPrimaryColorGreyDark:
                        AppColors.appPrimaryColorGreyLight,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            onTap: (){
                              _changeMoodForToday(MoodStateEnum.mweh);
                            },
                            child: Container(
                              padding: EdgeInsets.all(AppDimensions.paddingSmall),
                              child: Image.asset("assets/mweh.png", width: double.infinity)
                            )
                        ),
                      )
                  ),
                  Expanded(
                      flex:33,
                      child: Material(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        color: (widget.state==MoodStateEnum.ok)?
                        AppColors.appPrimaryColorGreyDark:
                        AppColors.appPrimaryColorGreyLight,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            onTap: (){
                              _changeMoodForToday(MoodStateEnum.ok);
                            },
                            child: Container(
                              padding: EdgeInsets.all(AppDimensions.paddingSmall),
                              child: Image.asset("assets/ok.png", width: double.infinity)
                            )
                        ),
                      )
                  ),
                ],
              ),
            )
          )
        ],
      )
    );
  }
}