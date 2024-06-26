import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_messages.dart';
import 'package:puftel/app/app_routes.dart';
import 'package:puftel/db/bloc/counter_bloc.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/main.dart';
import 'counter_detail_view.dart';
import 'counter_list_item.dart';

class CounterListView extends StatefulWidget{
  CounterListView({
    Key? key,
    required this.title}) : super(key: key);

  List<CounterModel> model = [];
  final String title;
  bool isProcessing = false;

  @override
  _CounterListViewState createState() => _CounterListViewState();
}

class _CounterListViewState extends State<CounterListView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  var bloc = CounterBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    MyApp.eventBloc.result.listen((event) {
      _fetchList();
    });

    bloc.getIncResult.listen((result) {
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
    bloc.getList();
  }

  Widget _buildNoItems(){
    return Container();
  }

  Widget _buildView(){
    return StreamBuilder(
        stream: bloc.getResult,
        builder: (context, AsyncSnapshot<List<CounterModel>> snapshot) {
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.model.length>0)? Container(): Container(
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.appPrimaryColorGreyDarker),
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              //TODO: translate
              child: Text("Er zijn geen tellers om te tonen. Klik op de + knop rechts bovenaan om nieuwe tellers toe te voegen.", style: TextStyle(color: AppColors.appPrimaryColorWhite),)),
          for (var item in widget.model)
            Column(
              children: [
                CounterListItem(item: item,
                  onCounterClick: (int id, int increment) {
                      bloc.inc(id, increment);
                      setState(() {});
                  },
                  onDetailsRequest: (CounterModel model) {
                    Navigator.pushNamed(
                        context,
                        AppRoutes.counterDetails,
                        arguments: CounterDetailsArguments(
                            model: model
                        )
                    );
                  },
                ),
                AppDimensions.verticalSmallSpacer,
              ],
            )
        ],
      ),
    );
  }
}