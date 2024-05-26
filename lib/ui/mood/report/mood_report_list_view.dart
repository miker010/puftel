import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_messages.dart';
import 'package:puftel/db/bloc/mood_bloc.dart';
import 'package:puftel/db/models/mood_model.dart';
import 'package:puftel/main.dart';
import 'mood_report_list_item.dart';

class MoodReportListView extends StatefulWidget{
  MoodReportListView({
    Key? key,
    required this.title}) : super(key: key);

  List<MoodModel> model = [];
  final String title;
  bool isProcessing = false;

  @override
  _MoodReportListViewState createState() => _MoodReportListViewState();
}

class _MoodReportListViewState extends State<MoodReportListView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  var bloc = MoodBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    MyApp.eventBloc.result.listen((event) {
      _fetchList();
    });

    _fetchList();
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build (BuildContext context) {
    if (widget.model != null){
      widget.isProcessing = false;
    }

    return _buildView();
  }

  _fetchList() async {
    // There is currently one 1 mood tracker
    bloc.getList(1);
  }

  Widget _buildNoItems(){
    return Container();
  }

  Widget _buildView(){
    return StreamBuilder(
        stream: bloc.getResult,
        builder: (context, AsyncSnapshot<List<MoodModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              widget.model = snapshot.data!;
              return _buildList(context);
            }
            else {
              return _buildList(context);
            }
          }
          else if (snapshot.hasError) {
            AppMessages.notify(context, "error", "Error");
          }
          return _buildList(context);
        }
    );
  }

  Widget _buildList(BuildContext context) {

    if (widget.model == null) {
      return _buildNoItems();
    }

    return Scaffold(
        appBar:  AppBar(
          backgroundColor: AppColors.appPrimaryColor,
          iconTheme: IconThemeData(
            color: AppColors.appPrimaryColorWhite,
          ),
          title: Text(
            MyApp.local.mood_how_it_went,
            style: TextStyle(color: AppColors.appPrimaryColorWhite)
          ),
          actions: [],
        ),
        //drawer: MenuView(),
        body: Container(
            margin: EdgeInsets.only(top: AppDimensions.marginSmall),
            padding: EdgeInsets.all(AppDimensions.marginSmall),
            child:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.model.length>0)? Container(): Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppColors.appPrimaryColorGreyDarker),
                      padding: EdgeInsets.all(AppDimensions.paddingMedium),
                      child: Text(
                        MyApp.local.mood_no_entries,
                        style: TextStyle(
                            color: AppColors.appPrimaryColorWhite)
                      )
                  ),
                  for (var item in widget.model)
                    Column(
                      children: [
                        MoodReportListItem(item: item),
                        AppDimensions.verticalSmallSpacer,
                      ]
                    )
                ],
              ),
            )
        )
    );
  }
}