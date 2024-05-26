import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/main.dart';

class AboutView extends StatefulWidget{
  AboutView({
    Key? key,
    required this.title}) : super(key: key);

  final String title;

  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {

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
          color: AppColors.appPrimaryColorWhite,
        ),
        title: Text(
          MyApp.local.appTitle,
          style: TextStyle(color: AppColors.appPrimaryColorWhite),),
        actions: [],
      ),
      body: Stack(
        children: [
          Container(),
          Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppDimensions.paddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(MyApp.local.about_title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold)
                            ),
                            AppDimensions.verticalMediumSpacer,
                            Text(MyApp.local.about_content),
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