import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_storage.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/reusables/widget_primary_button.dart';

class DisclaimerView extends StatefulWidget{
  DisclaimerView({
    Key? key,
    required this.title}) : super(key: key);

  final String title;

  @override
  _DisclaimerViewState createState() => _DisclaimerViewState();
}

class _DisclaimerViewState extends State<DisclaimerView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        iconTheme: IconThemeData(
          color: AppColors.appPrimaryColorWhite, //change your color here
        ),
        title: Text(MyApp.local.appTitle, style: TextStyle(color: AppColors.appPrimaryColorWhite),),
        actions: [

        ],
      ),

      body: Stack(
        children: [
          Container(

          ),
          Container(
            decoration: BoxDecoration(color: AppColors.appPrimaryColorGreyLight),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppDimensions.paddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(MyApp.local.disclaimer_title, style: TextStyle(fontWeight: FontWeight.bold),),
                            AppDimensions.verticalMediumSpacer,

                            Text(MyApp.local.disclaimer_content),
                            AppDimensions.verticalMediumSpacer,
                            WidgetPrimaryButton(labelText: MyApp.local.disclaimer_agree, onClicked: () async {
                                await AppStorage.setIsAgreed();
                                Navigator.of(context).pop();
                            }),
                            AppDimensions.verticalMediumSpacer,
                          ],
                        )
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}