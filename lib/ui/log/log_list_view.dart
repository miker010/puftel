import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_messages.dart';
import 'package:puftel/db/bloc/counter_bloc.dart';
import 'package:puftel/db/bloc/log_bloc.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/db/models/log_model.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/log/log_list_item.dart';

class LogListArguments {
  final int? counterid;

  LogListArguments({
    this.counterid});
}

class LogListView extends StatefulWidget{
  LogListView({
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
  _LogListViewState createState() => _LogListViewState();
}

class _LogListViewState extends State<LogListView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  var logBloc = LogBloc();
  var counterBloc = CounterBloc();

  CounterModel? dropdownValue;
  List<CounterModel> counterList = <CounterModel>[
    CounterModel(
        id: 0,
        name: MyApp.local.log_list_all_counters,
        value: 0,
        description: "")
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
          counterList.add(CounterModel(
              id: 0,
              name: MyApp.local.log_list_all_counters,
              value: 0,
              description: ""));

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
  }

  @override
  Widget build (BuildContext context) {
    if (widget.model != null){
      widget.isProcessing = false;
    }

    return _buildView();
  }

  LogListArguments? _getArgs(){
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args==null) { return null; }
    return args as LogListArguments;
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
          title: Text(
            MyApp.local.log_list_log_file,
            style: TextStyle(color: AppColors.appPrimaryColorWhite)
          ),
          actions: [],
        ),
        body: Container(
          margin: EdgeInsets.only(top: AppDimensions.marginSmall),
          padding: EdgeInsets.all(AppDimensions.marginSmall),
          child: Stack(
            children: [
              DropdownButton<CounterModel>(
                isExpanded: true,
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                style: const TextStyle(color: AppColors.appPrimaryColorBlack),
                underline: Container(
                  height: 2,
                  color: AppColors.appPrimaryColorBlueDark,
                ),
                onChanged: (CounterModel? value) {
                  dropdownValue = value!;
                  widget.counterId = (value.id==0)? null: value!.id;
                  _fetchList();
                },
                items: counterList.map<DropdownMenuItem<CounterModel>>(
                  (CounterModel value) {
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
                      (!widget.hasFetched || widget.model.length>0)?
                        Container():
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColors.appPrimaryColorGreyDarker),
                          padding: EdgeInsets.all(AppDimensions.paddingMedium),
                          child: Text(
                            MyApp.local.log_list_no_entries,
                            style: TextStyle(
                                color: AppColors.appPrimaryColorWhite)
                          )
                        ),
                      for (var item in widget.model)
                        Column(
                          children: [
                            LogListItem(item: item),
                            AppDimensions.verticalSmallSpacer,
                          ],
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