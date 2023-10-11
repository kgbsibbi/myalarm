import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:myalarm/provider/alarm_provider.dart';
import 'package:myalarm/service/local_notification.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model/alarm.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AlarmProvider _provider;

  @pragma('vm:entry-point')
  static Future<void> callback(int id) async {
    developer.log('Alarm $id fired!');
    LocalNotification.notify(id: 0, title: 'Alarm', body: 'Alarm $id Fired');
    Database db = await openDatabase('alarm_db.db');
    await db.delete('alarm', where:'id=?', whereArgs:[id]);
  }

  Future<Alarm> saveAlarm(TimeOfDay selectedTime) async {
    var now = DateTime.now();
    var alarmTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    // 현재 시각 보다 이전 시각을 선택할 경우 내일 울리도록 한다.
    if(now.compareTo(alarmTime) > 0){
      alarmTime = alarmTime.add(const Duration(days: 1));
    }
    developer.log('alarm time - ${alarmTime.month}/${alarmTime.day} ${alarmTime.hour} : ${alarmTime.minute}');

    int id = Random().nextInt(pow(2, 31) as int);

    // Alarm 설정
    await AndroidAlarmManager.oneShotAt(
        alarmTime,
        id,
        callback,
        exact: true,
        allowWhileIdle: true,
        wakeup: true,
        rescheduleOnReboot: true);

    return Alarm.fromData(id, alarmTime);
  }

  @override
  void initState(){
    super.initState();
    AndroidAlarmManager.initialize();
    LocalNotification.initialize();
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AlarmProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Alarm'),
      ),
      body:StreamBuilder<List<Alarm>>(
        stream:_provider.getAlarmsStream(),
        builder: (context, snapshot){
          if(snapshot.hasData) {
            return createList();
          } else {
            return const SizedBox(width: 10, height: 10,);
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          TimeOfDay? selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now()
          );
          if(selectedTime != null){
            developer.log('selected time - ${selectedTime.hour} : ${selectedTime.minute}');
            Alarm alarm = await saveAlarm(selectedTime);
            _provider.insert(alarm);
          }
        },
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget createList(){
    return Center(
        child: ListView.builder(
        itemCount: _provider.alarms.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index){
          return _AlarmCard(
            alarm: _provider.alarms[index],
            onClose: (){
              AndroidAlarmManager.cancel(_provider.alarms[index].id!);
              _provider.delete(_provider.alarms[index].id!);
            });
        },
      )
    );
  }
}


class _AlarmCard extends StatelessWidget {
  const _AlarmCard({
    Key? key,
    required this.alarm,
    required this.onClose
  }) : super(key: key);

  final Alarm alarm;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${alarm.time?.hour}:${alarm.time?.minute}',
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(1.0)
                  ),
                ),
              ),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close))
            ],
          ),
        ),
      ),
    );
  }
}

