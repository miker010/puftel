import 'package:puftel/app/app_storage.dart';
import 'package:puftel/db/app_db_manager.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/db/models/medicine_model.dart';
import 'package:puftel/main.dart';
import 'package:rxdart/rxdart.dart';

class MedicineBloc {

  final _dbManager = AppDBManager();

  final _fetcher = PublishSubject<List<MedicineModel>>();
  Stream<List<MedicineModel>> get getResult => _fetcher.stream;

  getList() async {
    await _dbManager.init();

    List<MedicineModel> result = [];

    var model = await _dbManager.getMedicines();

    final isInternational = await AppStorage.getIsInternational();

    model.forEach((medicine) {
      switch(medicine.name){
        case "Salbutamol":
          result.add(MedicineModel(id: medicine.id,
              color: medicine.color, name: medicine.name,
              link: (isInternational)? "" : medicine.link,
              description: MyApp.local.preset_medicine_salbutomol));
          break;
        case "Qvar":
          result.add(MedicineModel(id: medicine.id,  link: (isInternational)? "" : medicine.link,
              color: medicine.color, name: medicine.name,
              description: MyApp.local.preset_medicine_qvar));
          break;
        case "Foster":
          result.add(MedicineModel(id: medicine.id,  link: (isInternational)? "" : medicine.link,
              color: medicine.color, name: medicine.name,
              description: MyApp.local.preset_medicine_foster));
          break;
      }
    });

    _fetcher.sink.add(result);
  }

  add(MedicineModel model) async {
    await _dbManager.init();
    await _dbManager.insertMedicine(model);
  }

  dispose() {
    _fetcher.close();
  }
}