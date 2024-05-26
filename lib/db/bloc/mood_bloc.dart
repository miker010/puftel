import 'package:puftel/db/app_db_manager.dart';
import 'package:puftel/db/models/counter_inc_result.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/db/models/log_model.dart';
import 'package:puftel/db/models/medicine_model.dart';
import 'package:puftel/db/models/mood_model.dart';
import 'package:puftel/ui/mood/mood_state_enum.dart';
import 'package:rxdart/rxdart.dart';

class MoodBloc {

  final _dbManager = AppDBManager();
  bool _initialized = false;

  final _fetcher = PublishSubject<List<MoodModel>>();
  Stream<List<MoodModel>> get getResult => _fetcher.stream;

  final _todayFetcher = PublishSubject<MoodModel?>();
  Stream<MoodModel?> get getTodayResult => _todayFetcher.stream;

  final _updateFetcher = PublishSubject<MoodModel>();
  Stream<MoodModel> get updateResult => _updateFetcher.stream;

  _init() async {
    if (_initialized) return;

    await _dbManager.init();
  }

  getList(int moodTypeId) async {
    await _init();
    var model = await _dbManager.getMoods(moodTypeId);
    _fetcher.sink.add(model);
  }

  getTodaysMood(int moodTypeId) async {
    await _init();
    var model = await _dbManager.getTodaysMood(moodTypeId);
    _todayFetcher.sink.add(model);
  }

  setTodaysMood(MoodStateEnum state, int moodType) async {
    await _init();
    _dbManager.setTodaysMood(state, moodType);
  }


}