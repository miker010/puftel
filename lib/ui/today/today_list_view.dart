import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_messages.dart';
import 'package:puftel/db/bloc/log_bloc.dart';
import 'package:puftel/db/models/log_model.dart';
import 'package:puftel/db/models/today_model.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/today/today_list_item.dart';

class TodayListView extends StatefulWidget{
  TodayListView({
    Key? key,
    required this.title}) : super(key: key);

  List<TodayModel> model = [];
  final String title;
  bool isProcessing = false;
  List<LogModel>? logModel;

  @override
  _TodayListViewState createState() => _TodayListViewState();
}

class _TodayListViewState extends State<TodayListView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  var bloc = LogBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    MyApp.eventBloc.result.listen((event) {
      _fetchList();
      _fetchAllLogsForToday();
    });

    bloc.getResult.listen((event) {
      setState(() {
        widget.logModel = event;
      });
    });

    _fetchList();
    _fetchAllLogsForToday();
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
    bloc.getTodaysTotals();
  }

  _fetchAllLogsForToday() async {
    bloc.getListForToday();
  }

  Widget _buildNoItems(){
    return Container();
  }

  Widget _buildView(){
    return StreamBuilder(
        stream: bloc.getTodayTotalsResult,
        builder: (context, AsyncSnapshot<List<TodayModel>> snapshot) {
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
          color: AppColors.appPrimaryColorWhite
        ),
        title: Text(
          "${MyApp.local.today} ${DateFormat('dd MMM yyyy').format(DateTime.now())}",
          style: TextStyle(
              color: AppColors.appPrimaryColorWhite)
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
                (widget.model.length>0)?
                  Container()
                  :
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.appPrimaryColorGreyDarker),
                      padding: EdgeInsets.all(AppDimensions.paddingMedium),
                      child: Text(
                        MyApp.local.today_no_entries,
                        style: TextStyle(color: AppColors.appPrimaryColorWhite)
                      )
                  ),
                  for (var item in widget.model)
                    Column(
                      children: [
                        TodayListItem(item: item, logs: widget.logModel),
                        AppDimensions.verticalSmallSpacer,
                      ],
                    )
              ],
            ),
          )
        )
      );
   }
}