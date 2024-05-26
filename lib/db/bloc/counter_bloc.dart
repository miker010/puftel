import 'package:puftel/db/app_db_manager.dart';
import 'package:puftel/db/models/counter_inc_result.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc {

  final _dbManager = AppDBManager();
  bool _initialized = false;

  final _fetcher = PublishSubject<List<CounterModel>>();
  Stream<List<CounterModel>> get getResult => _fetcher.stream;

  final _incFetcher = PublishSubject<CounterIncResult>();
  Stream<CounterIncResult> get getIncResult => _incFetcher.stream;

  _init() async {
    if (_initialized) return;

    await _dbManager.init();
  }

  getList() async {
    await _init();
    var model = await _dbManager.getCounters();
    _fetcher.sink.add(model);
  }

  reset (int id) async {
    await _init();
    final value = await _dbManager.resetCounter(id);
    _incFetcher.sink.add(CounterIncResult(id: id, newValue: value));
  }

  delete (int id) async {
    await _init();
    await _dbManager.deleteCounter(id);
  }

  setTexts (int id, String title, String description) async {
    await _init();
    await _dbManager.setTexts(id, title, description);
  }

  setColor (int id, int value) async {
    await _init();
    await _dbManager.setColor(id, value);
  }

  setMaxCount(int id, int value) async {
    await _init();
    await _dbManager.setMaxCount(id, value);
  }

  setWarningCount(int id, int value) async {
    await _init();
    await _dbManager.setWarningCount(id, value);
  }

  inc(int id, int increment) async {
    await _init();
    var value = await _dbManager.incCounter(id, increment);
    if (value<=0){
      reset(id);
      value = 0;
    }
    _incFetcher.sink.add(CounterIncResult(id: id, newValue: value));
  }

  update(CounterModel model) async {
    await _init();
    _dbManager.updateCounter(model);
  }

  add(CounterModel model) async {
    await _init();
    _dbManager.insertCounter(model);
  }

  dispose() {
    _fetcher.close();
  }
}