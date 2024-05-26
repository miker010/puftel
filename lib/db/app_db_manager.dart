import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:puftel/app/app_storage.dart';
import 'package:puftel/db/models/counter_model.dart';
import 'package:puftel/db/models/log_model.dart';
import 'package:puftel/db/models/medicine_model.dart';
import 'package:puftel/db/models/today_model.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/mood/mood_state_enum.dart';
import 'package:sqflite/sqflite.dart';
import 'models/mood_model.dart';
import 'models/mood_type_model.dart';

class AppDBManager {
  Database? database;
  final int dbVersion = 2;

  init() async {
    WidgetsFlutterBinding.ensureInitialized();

      database =  await openDatabase(
      join(await getDatabasesPath(), 'puftel_database_022.db'),

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion<newVersion){
          if (newVersion==2){
            await db.execute('CREATE TABLE moodType (id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
            await db.execute('CREATE TABLE mood (id INTEGER PRIMARY KEY, dateTime INTEGER, value INTEGER, description TEXT, moodTypeId INTEGER)');

            var moodTypeId = await AppStorage.getNewId("moodType");
            await insertMoodType(MoodTypeModel(
                id: moodTypeId,
                description: "Algemeen",
                title: "Algemeen"));
          }
        }
      },
      onCreate: (db, version) async {
        if (version>=1) {
          await db.execute(
              'CREATE TABLE counter(id INTEGER PRIMARY KEY, name TEXT, value INTEGER, description TEXT, maxCount INTEGER, warningAtCount INTEGER, color INTEGER, link TEXT)');
          await db.execute(
              'CREATE TABLE log (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, dateTime INTEGER, color INTEGER, counterId INTEGER)');
          await db.execute(
              'CREATE TABLE medicine (id INTEGER PRIMARY KEY, name TEXT, description TEXT, color INTEGER, link TEXT)');
        }

        if (version>=2) {
          await db.execute('CREATE TABLE moodType (id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
          await db.execute('CREATE TABLE mood (id INTEGER PRIMARY KEY, dateTime INTEGER, value INTEGER, description TEXT, moodTypeId INTEGER)');
        }

        database = db;
        var moodTypeId = await AppStorage.getNewId("moodType");
        await insertMoodType(MoodTypeModel(
            id: moodTypeId,
            description: "Algemeen",
            title: "Algemeen"));

        var medicineId = await AppStorage.getNewId("medicine");
        await insertMedicine(MedicineModel(
          id: medicineId, name: "Salbutamol",
          color: 0,
          link : 'https://www.apotheek.nl/medicijnen/beclometason-inhalatie?product=ventalin',
          description: MyApp.local.preset_medicine_salbutomol,
        ));

        medicineId = await AppStorage.getNewId("medicine");
        await insertMedicine(MedicineModel(
          id: medicineId, name: "Qvar",
          color: 1,
          link: 'https://www.apotheek.nl/medicijnen/beclometason-inhalatie?product=qvar',
          description: MyApp.local.preset_medicine_qvar,
        ));

        medicineId = await AppStorage.getNewId("medicine");
        await insertMedicine(MedicineModel(
          id: medicineId, name: "Foster",
          color: 2,
          description: MyApp.local.preset_medicine_foster,
          link: 'https://www.apotheek.nl/medicijnen/beclometason-inhalatie?product=foster'
        ));

        final counterId = await AppStorage.getNewId("counter");
        await insertCounter(CounterModel(
            id: counterId,
            name: "Salbutamol",
            color: 0,
            description: MyApp.local.preset_medicine_salbutomol,
            maxCount: 200,
            warningAtCount: 180,
            value: 0));
      },

      version: dbVersion,
    );
  }

  Future<MoodModel?> getTodaysMood(int moodTypeId) async {
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}${now.month.toString().padLeft(2,'0')}${now.day.toString().padLeft(2,'0')}";
    int dateAsInt = int.parse(formattedDate);

    final List<Map<String, dynamic>> maps =
    await database!.rawQuery("select * from mood"+
        " where dateTime = " + dateAsInt.toString()+
        " and moodTypeId = "+moodTypeId.toString()+
        " order by dateTime DESC LIMIT 1");

    if (maps.length==1) {
      return MoodModel(
        id: maps[0]['id'],
        description: maps[0]['description'],
        value: maps[0]['value'],
        dateTime: maps[0]['dateTime'],
        moodTypeId: maps[0]['moodTypeId'],
      );
    }

   return null;
  }

  Future<void> setTodaysMood(MoodStateEnum state, int moodTypeId) async {
    var mood = await getTodaysMood(moodTypeId);

    if (mood!=null) {
      final sql = "update mood set value = ${state.index} where id = ${mood.id}";
      if (await database!.rawUpdate(sql)>0){
        return;
      }
      else {
        Logger().e("Cannot update mood");
        return;
      }
    }
    else {
      var moodId = await AppStorage.getNewId("mood");
      DateTime now = DateTime. now();
      String formattedDate = "${now.year}${now.month.toString().padLeft(
          2, '0')}${now.day.toString().padLeft(2, '0')}";
      int dateAsInt = int.parse(formattedDate);

      var model = MoodModel(
          id: moodId,
          dateTime: dateAsInt, value: state.index, moodTypeId: moodTypeId);

      await insertMood(model);
    }
  }

  Future<void> insertMoodType(MoodTypeModel model) async {
    await database?.insert(
      'moodType',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMood(MoodModel model) async {
    await database?.insert(
      'mood',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertCounter(CounterModel model) async {
    await database?.insert(
      'counter',
       model.toMap(),
       conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertLog(LogModel model) async {
    await database?.insert(
      'log',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMedicine(MedicineModel model) async {
    await database?.insert(
      'medicine',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  int _getTodayFrom(){
    final now = DateTime.now();
    final value = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    return value.millisecondsSinceEpoch;
  }

  int _getToDayTo(){
    final now = DateTime.now();
    final value = DateTime(now.year, now.month, now.day, 23, 59, 59, 0, 0);
    return value.millisecondsSinceEpoch;
  }

  Future<List<TodayModel>> getTodaysTotals() async {
    final fromDate = _getTodayFrom();
    final toDate = _getToDayTo();

    final List<Map<String, dynamic>> maps =
    await database!.rawQuery(
        " select a.*, c.name from ( select sum(value) as sumValue, MIN(counterId) as counterId  from log "+
            " where "+
            " dateTime >= " + fromDate.toString() +
            " and dateTime <= " + toDate.toString() +
            " group by counterId ) a"+
            " join counter c on a.counterId = c.id "+
            " order by c.id"
    );

    var result = List.generate(maps.length, (i) {
      return TodayModel(
        id: maps[i]['counterId'],
        name: maps[i]['name'],
        value: maps[i]['sumValue']
      );
    });

    return result;
  }

  Future<int> getTodaysTotal(int counterId) async {
    final fromDate = _getTodayFrom();
    final toDate = _getToDayTo();

    final List<Map<String, dynamic>> maps =
      await database!.rawQuery(
        " select * from ( "+
        " select sum(value) as sumValue from log "+
        " where counterId = " + counterId!.toString() +" "+
        " and dateTime >= " + fromDate.toString() +
        " and dateTime <= " + toDate.toString() +
        " order by dateTime ) a");

    if (maps.length>0){
      final result = maps.first['sumValue'];
      if (result==null) { return 0;}
      return result;
    }
    else {
      return 0;
    }
  }

  Future<LogModel?> getLastLog(int? counterId) async {
    final List<Map<String, dynamic>> maps =
    (counterId==null) ?
      await database!.rawQuery("select * from log "+
        "order by dateTime DESC LIMIT 1")
      :
      await database!.rawQuery("select * from log "+
        "where counterId = " + counterId!.toString() +" "+
        "and value > 0 "+
        "order by dateTime DESC LIMIT 1");

    var result = List.generate(maps.length, (i) {
      return LogModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        value: maps[i]['value'],
        dateTime: maps[i]['dateTime'],
        counterId: maps[i]['counterId'],
      );
    });

    return result.firstOrNull;
  }

  Future<List<MoodModel>> getMoods(int? moodTypeId) async {
    final List<Map<String, dynamic>> maps =
    (moodTypeId==null) ?
    await database!.rawQuery("select * from mood "+
        "order by dateTime DESC LIMIT 2500")
    :
    await database!.rawQuery("select * from mood where moodTypeId = "+
        moodTypeId!.toString()+" "+
        "order by dateTime DESC LIMIT 2500");

    return List.generate(maps.length, (i) {
      return MoodModel(
        id: maps[i]['id'],
        value: maps[i]['value'],
        dateTime: maps[i]['dateTime'],
        moodTypeId: maps[i]['moodTypeId'],
      );
    });
  }

  Future<List<LogModel>> getLogs(int? counterId, bool? forToday) async {
    final fromDate = _getTodayFrom();
    final toDate = _getToDayTo();

    final List<Map<String, dynamic>> maps =
    (counterId==null && forToday != true) ?
      await database!.rawQuery("select * from log "+
        "order by dateTime DESC LIMIT 2500")
    :
    (forToday==true)?
      await database!.rawQuery("select * from log "+
          " where dateTime >= " + fromDate.toString() +
          " and dateTime <= " + toDate.toString() +
          " order by dateTime DESC LIMIT 2500")
    :
    await database!.rawQuery("select * from log "+
        "where counterId = " + counterId!.toString() +" "+
        "order by dateTime DESC LIMIT 2500");

    return List.generate(maps.length, (i) {
      return LogModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        value: maps[i]['value'],
        dateTime: maps[i]['dateTime'],
        counterId: maps[i]['counterId'],
      );
    });
  }

  Future<List<CounterModel>> getCounters() async {
    final List<Map<String, dynamic>> maps = await database!.query('counter');
    return List.generate(maps.length, (i) {
      return CounterModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        value: maps[i]['value'],
        warningAtCount: maps[i]['warningAtCount'],
        maxCount: maps[i]['maxCount'],
        color: maps[i]['color'],
        link: maps[i]['link'],
      );
    });
  }

  Future<int> getCounterValue(int id) async {
    final sql = "select * from counter where id = "+id.toString();
    final List<Map<String, dynamic>> maps = await database!.rawQuery(sql);
    final item = maps.first;
    final value = item["value"] as int;
    return value;
  }

  Future<void> deleteCounter(int id) async {
    final sql = "delete from counter where id = ${id}";
    await database!.rawUpdate(sql);
  }

  Future<int> resetCounter(int id) async {
    final sql = "update counter set value = 0 where id = ${id}";
    if (await database!.rawUpdate(sql)>0){
      return 0;
    }
    else {
      return 0;
    }
  }

  Future<void> setTexts (int id , String title, String description) async {
    final sql = "update counter set name = '${title}' where id = ${id}";
    await database!.rawUpdate(sql);
    final sql2 = "update counter set description = '${description}' where id = ${id}";
    await database!.rawUpdate(sql2);
  }

  Future<void> setColor  (int id, int value) async {
    final sql = "update counter set color = ${value} where id = ${id}";
    await database!.rawUpdate(sql);
  }

  Future<void> setMaxCount (int id, int value) async {
    final sql = "update counter set maxCount = ${value} where id = ${id}";
    await database!.rawUpdate(sql);
  }

  Future<void> setWarningCount (int id, int value) async {
    final sql = "update counter set warningAtCount = ${value} where id = ${id}";
    await database!.rawUpdate(sql);
  }

  Future<int> incCounter(int id, int increment) async {
   final currentValue = await getCounterValue(id);
   final sql = "update counter set value = ${currentValue+increment} where id = ${id}";
   if (await database!.rawUpdate(sql)>0){
     return currentValue+increment;
   }
   else {
     return currentValue;
   }
  }

  Future<void> updateCounter(CounterModel model) async {
    await database?.update(
      'counter',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<List<MedicineModel>> getMedicines() async {
    final List<Map<String, dynamic>> maps = await database!.query('medicine');
    return List.generate(maps.length, (i) {
      return MedicineModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        color: maps[i]['color'],
        link: maps[i]['link'],
        description: maps[i]['description'],
      );
    });
  }

}