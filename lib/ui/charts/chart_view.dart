import 'dart:async';

import 'package:charts_painter/chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_messages.dart';
import 'package:puftel/app/app_routes.dart';
import 'package:puftel/app/app_storage.dart';
import 'package:puftel/db/app_db_manager.dart';
import 'package:puftel/db/bloc/counter_bloc.dart';
import 'package:puftel/db/bloc/log_bloc.dart';
import 'package:puftel/db/bloc/medicine_bloc.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/db/models/log_model.dart';
import 'package:puftel/db/models/medicine_model.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/log/log_list_item.dart';
import 'package:puftel/ui/medicine/medicine_list_item.dart';
import 'package:puftel/ui/menu/menu_view.dart';
import 'package:puftel/ui/reusables/widget_button_nav_bart.dart';


class ChartViewArguments {
  final int? counterid;

  ChartViewArguments({
    this.counterid});
}


class ChartView extends StatefulWidget{
  ChartView({
    Key? key,
    required this.title,
    this.counterId
  }) : super(key: key);

  List<LogModel> model = [];
  final String title;
  int? counterId;
  bool isProcessing = false;
  bool hasFetched = false;

  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  var logBloc = LogBloc();
  var counterBloc = CounterBloc();

  CounterModel? dropdownValue;
  List<CounterModel> counterList = <CounterModel>[
    CounterModel(id: 0, name: MyApp.local.log_list_all_counters, value: 0, description: "")
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);


    MyApp.eventBloc.result.listen((event) {
      if (mounted) {
        _fetchList();
      }
    });

    counterBloc.getResult.listen((counterListData) {
      setState(() {
        counterList.clear();
        counterList.add(CounterModel(id: 0, name: "Alle tellers", value: 0, description: ""));

        counterListData.forEach((counter) {
          counterList.add(counter);
        });


        if (widget.counterId==null) {
          dropdownValue = counterList.first;
        }
        else {
          counterList.forEach((element) {
            if (element.id == widget.counterId) {
              dropdownValue = element;
            }
          });
        }
      });
    });

    Future.delayed(const Duration(milliseconds: 500), () {

      widget.counterId = _getArgs()?.counterid;

      _fetchList();
      counterBloc.getList();
    });
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    //
  }

  @override
  Widget build (BuildContext context) {

    if (widget.model != null){
      widget.isProcessing = false;
    }

    return _buildView();
  }

   ChartViewArguments? _getArgs(){
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args==null) { return null; }
    return args as ChartViewArguments;
  }

  _fetchList() async {
    logBloc.getList(counterId: widget.counterId);
    widget.hasFetched = true;
  }

  Widget _buildNoItems(){
    return Container();
  }

  Widget _buildView(){
    return StreamBuilder(
        stream: logBloc.getResult,
        builder: (context, AsyncSnapshot<List<LogModel>> snapshot) {
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

  Widget _getChart(BuildContext context){
    return Chart(
      state: ChartState<void>(
          data: ChartData(
              [[0,1,1,1,2,2,2].map((e) => ChartItem<void>(1+e.toDouble())).toList()]
          ),
          itemOptions: BarItemOptions(barItemBuilder: (itemBuilderData) {
            
            // Setting the different color based if the item is from first or second list
            return BarItem(color:
                (itemBuilderData.item.max==1)? AppColors.appPrimaryColorRed :
                (itemBuilderData.item.max==2)? AppColors.appPrimaryColorBlue:
                    AppColors.appPrimaryColorGreen);

          }),

          backgroundDecorations: [
          HorizontalAxisDecoration(axisStep: 2, showValues: true),
          VerticalAxisDecoration(axisStep: 2, showValues: true)
        ]
          //backgroundDecorations: [
          //  HorizontalDecoration(axisStep: 2, showValues: true),
          //]
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Apr';
        break;
      case 1:
        text = 'May';
        break;
      case 2:
        text = 'Jun';
        break;
      case 3:
        text = 'Jul';
        break;
      case 4:
        text = 'Aug';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
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
            color: AppColors.appPrimaryColorWhite, //change your color here
          ),
          title: Text("Logboek", style: TextStyle(color: AppColors.appPrimaryColorWhite),),
          actions: [
          ],
        ),
        //drawer: MenuView(),
        body: Container(
            margin: EdgeInsets.only(top: AppDimensions.marginSmall),
            padding: EdgeInsets.all(AppDimensions.marginSmall),
            child: Stack(
              children: [
                DropdownButton<CounterModel>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  // elevation: 16,
                  style: const TextStyle(color: AppColors.appPrimaryColorBlack),
                  underline: Container(
                    height: 2,
                    color: AppColors.appPrimaryColorBlueDark,
                  ),
                  onChanged: (CounterModel? value) {
                    // This is called when the user selects an item.
                    //setState(() {
                    dropdownValue = value!;
                    widget.counterId = (value.id==0)? null: value!.id;
                    _fetchList();
                    //});
                  },
                  items: counterList.map<DropdownMenuItem<CounterModel>>((CounterModel value) {
                    return DropdownMenuItem<CounterModel>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),

                Container(
                    margin: EdgeInsets.only(top:48),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (!widget.hasFetched || widget.model.length>0)? Container(): Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: AppColors.appPrimaryColorGreyDarker),
                              padding: EdgeInsets.all(AppDimensions.paddingMedium),
                              child: Text(MyApp.local.chart_no_graphs, style: TextStyle(color: AppColors.appPrimaryColorWhite),)),
                              Container(
                                child:
                                    _getChart(context)
                              )
                        ],
                      ),
                    )
                )
              ],
            )
        )
    );
  }
}