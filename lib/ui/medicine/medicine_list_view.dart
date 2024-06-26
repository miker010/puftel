import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_messages.dart';
import 'package:puftel/app/app_routes.dart';
import 'package:puftel/db/bloc/counter_bloc.dart';
import 'package:puftel/db/bloc/medicine_bloc.dart';
import 'package:puftel/db/models/medicine_model.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/medicine/medicine_add_view.dart';
import 'package:puftel/ui/medicine/medicine_list_item.dart';

class MedicineListView extends StatefulWidget{
  MedicineListView({
    Key? key,
    required this.title}) : super(key: key);

  List<MedicineModel> model = [];
  final String title;
  bool isProcessing = false;

  @override
  _MedicineListViewState createState() => _MedicineListViewState();
}

class _MedicineListViewState extends State<MedicineListView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  var counterBloc = CounterBloc();
  var medicineBloc = MedicineBloc();

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
    medicineBloc.getList();
  }

  _selectMedicine(MedicineModel model) async {
    Navigator.of(context).pop();
    Navigator.pushNamed(
        context,
        AppRoutes.medicineAdd,
        arguments: MedicineAddArguments(model: model)
    );
  }

  Widget _buildNoItems(){
    return Container();
  }

  Widget _buildView(){
    return StreamBuilder(
        stream: medicineBloc.getResult,
        builder: (context, AsyncSnapshot<List<MedicineModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              widget.model = snapshot.data!;
              widget.model.add(MedicineModel(
                  id: 0,
                  name: MyApp.local.medicine_list_view_other_medicine,
                  description: MyApp.local.medicine_list_view_other_medicine_description));
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
        title: Text(MyApp.local.medicine_list_view_add,
          style: TextStyle(
              color: AppColors.appPrimaryColorWhite)
        ),
        actions: [ ],
      ),
      //drawer: MenuView(),
      body: Container(
        margin: EdgeInsets.only(top: AppDimensions.marginMedium),
        padding: EdgeInsets.all(AppDimensions.marginSmall),
        child: SingleChildScrollView(
          child:
              Column(
                children:
                [
                  for (var item in widget.model)
                    Column(
                      children: [
                        MedicineListItem(
                            item: item,
                            onMedicineSelected: (model) {
                              _selectMedicine(item);
                            }
                        ),
                        AppDimensions.verticalSmallSpacer,
                      ],
                    )
                ],
             )
            )
        )
    );
  }
}