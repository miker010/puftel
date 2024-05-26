import 'package:puftel/app/app_storage.dart';
import 'package:puftel/db/app_db_manager.dart';
import 'package:puftel/db/models/log_model.dart';
import 'package:puftel/db/models/today_model.dart';
import 'package:rxdart/rxdart.dart';

class LogBloc {
  final _dbManager = AppDBManager();
  final _fetcher = PublishSubject<List<LogModel>>();
  Stream<List<LogModel>> get getResult => _fetcher.stream;
  final _todayTotalsfetcher = PublishSubject<List<TodayModel>>();
  Stream<List<TodayModel>> get getTodayTotalsResult => _todayTotalsfetcher.stream;

  Future<List<TodayModel>> getTodaysTotals() async {
    await _dbManager.init();
    var model = await _dbManager.getTodaysTotals();
    _todayTotalsfetcher.sink.add(model);
    return model;
  }

  Future<int> getTodaysTotal(int counterId) async {
    await _dbManager.init();
    var model = await _dbManager.getTodaysTotal(counterId);
    return model;
  }

  Future<LogModel?> getLast({int? counterId = null}) async {
    await _dbManager.init();
    var model = await _dbManager.getLastLog(counterId);
    return model;
  }
  getList({int? counterId = null}) async {
    await _dbManager.init();
    var model = await _dbManager.getLogs(counterId, false);
    _fetcher.sink.add(model);
  }

  getListForToday() async {
    await _dbManager.init();
    var model = await _dbManager.getLogs(null, true);
    _fetcher.sink.add(model);
  }

  addEntry(String entry, int value, int counterId) async {
    final newId = await AppStorage.getNewId("log");
    final model = LogModel(
        id: newId,
        dateTime: DateTime.now().millisecondsSinceEpoch,
        name: entry,
        value: value,
        counterId:  counterId
    );
    add(model);
  }

  add(LogModel model) async{
    await _dbManager.init();
    _dbManager.insertLog(model);
  }

  dispose() {
    _fetcher.close();
  }
}