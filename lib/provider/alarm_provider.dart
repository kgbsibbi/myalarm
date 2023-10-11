import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:myalarm/model/alarm.dart';

class AlarmProvider extends ChangeNotifier{
  late Database _db;
  late List<Alarm> alarms = List.empty();

  AlarmProvider(){
    open();
  }

  Future<void> open() async{
    _db = await openDatabase(
      'alarm_db.db',
      version:1,
      onCreate:(Database db, int version) async {
        await db.execute('Create table alarm(id integer primary key, year integer, month integer, day integer, hour integer, minute integer)');
      },
      onUpgrade:(Database db, int oldVersion, int version) async {
      }
    );
    await getAlarms();
  }

  Future<List<Alarm>> getAlarms() async {
    List<Map> maps = await _db.query('alarm');
    alarms = List.empty(growable: true);
    for (var element in maps) {
      alarms.add(Alarm.fromMap(element as Map<String, Object?>));
    }
    notifyListeners();
    return alarms;
  }

  Stream<List<Alarm>> getAlarmsStream() {
    return Stream.fromFuture(getAlarms());
  }

  Future<void> insert(Alarm alarm) async{
    int result = await _db.insert('alarm', alarm.toMap());
    debugPrint(result.toString());
  }

  Future<void> delete(int id) async {
    await _db.delete('alarm', where:'id=?', whereArgs:[id]);
  }
}