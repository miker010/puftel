
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_routes.dart';
import 'package:puftel/app/app_storage.dart';
import 'package:puftel/db/bloc/mood_bloc.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/counter/counter_list_view.dart';
import 'package:puftel/ui/menu/menu_view.dart';
import 'package:puftel/ui/mood/input/mood_input_view.dart';
import 'package:puftel/ui/mood/mood_state_enum.dart';
import 'package:puftel/ui/reusables/widget_button_nav_bart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardView extends StatefulWidget{
  DashboardView({
    Key? key,
    required this.title}) : super(key: key);

  final String title;
  MoodStateEnum? currentMoodState;

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with WidgetsBindingObserver {


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
      // App is resumed (foreground)
      // Dit is vergelijkbaar met 'onResume' in Android
        print('App Lifecycle: resumed');
        setState(() {
          Logger().d("dashboard - resume - refresh");
        });
        _checkMood();
        break;
      case AppLifecycleState.inactive:
      // App is in an inactive state and is not receiving user input
      // Dit gebeurt bijvoorbeeld bij tijdelijke onderbrekingen zoals een inkomend gesprek
        print('App Lifecycle: inactive');
        break;
      case AppLifecycleState.paused:
      // App is paused (background)
      // Dit is vergelijkbaar met 'onPause' in Android
        print('App Lifecycle: paused');
        break;
      case AppLifecycleState.detached:
      // App is detached from the view
      // Dit gebeurt als de view hosting de Flutter-app is verwijderd
        print('App Lifecycle: detached');
        break;
    }
  }

  var bloc = MoodBloc();

  @override
  void didChangeDependencies() {


    super.didChangeDependencies();
  }

  _addMedicine() {
    Navigator.pushNamed(
        context,
        AppRoutes.medicineList,
    );
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    _checkIsInternational();
    _checkAgreement();
    _checkMood();
  }

  _checkMood(){
    bloc.getTodayResult.listen((todayMood) {
      if (todayMood != null){
        setState(() {
          Logger().d("Found todays mood for type 1. Todays mood = ${todayMood.value}");
          switch(todayMood.value){
            case 0: widget.currentMoodState = MoodStateEnum.sad; break;
            case 1: widget.currentMoodState = MoodStateEnum.mweh; break;
            case 2: widget.currentMoodState = MoodStateEnum.ok; break;
          }
        });
      }
      else {
        Logger().d("Not found todays mood for type 1. No mood defined yet for today.");
      }
    });

    Logger().d("Check todays mood for type 1");
    bloc.getTodaysMood(1);
  }
  _checkIsInternational() async {
    MyApp.isInternational = await AppStorage.getIsInternational();
  }

  _checkAgreement() async{
    final agreed = await AppStorage.getIsAgreed();
    if (!agreed){
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushNamed(AppRoutes.disclaimer);
      });
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {

    MyApp.local = AppLocalizations.of(context);


    return Scaffold(
      appBar:  AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        iconTheme: IconThemeData(
          color: AppColors.appPrimaryColorWhite, //change your color here
        ),
        title: Text(MyApp.local.appTitle, style: TextStyle(color: AppColors.appPrimaryColorWhite),),
        actions: [
          WidgetButtonNavBar(
            icon: Icons.add,
            onClicked: () {
              _addMedicine();
            }, title: '',
          )
        ],
      ),
      drawer: MenuView(),
      body: Stack(
        children: [
          Container(

          ),
          Container(
            decoration: BoxDecoration(color: AppColors.appPrimaryColorWhite),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppDimensions.paddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MoodInputView(state: widget.currentMoodState),
                            CounterListView(title: "")
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