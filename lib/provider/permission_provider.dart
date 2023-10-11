import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider extends ChangeNotifier{
  late PermissionStatus alarmStatus;
  late PermissionStatus alertWindowStatus;
  late PermissionStatus notificationStatus;
  get allGranted => alarmStatus.isGranted && alertWindowStatus.isGranted && notificationStatus.isGranted;

  PermissionProvider() {
    alarmStatus = PermissionStatus.denied;
    alertWindowStatus = PermissionStatus.denied;
    notificationStatus = PermissionStatus.denied;
    checkPermissions();
  }


  Future<void> requestAlarmPermission() async {
    alarmStatus = await Permission.scheduleExactAlarm.status;
    if(alarmStatus != PermissionStatus.granted) {
      alarmStatus = await Permission.scheduleExactAlarm.request();
    }
    notifyListeners();
  }

  Future<void> requestAlertWindowPermission() async {
    alertWindowStatus = await Permission.systemAlertWindow.status;
    if(alertWindowStatus != PermissionStatus.granted){
      alertWindowStatus= await Permission.systemAlertWindow.request();
    }
    notifyListeners();
  }

  Future<void> requestNotificationPermission() async {
    notificationStatus = await Permission.notification.status;
    if(notificationStatus != PermissionStatus.granted){
      notificationStatus= await Permission.notification.request();
    }
    notifyListeners();
  }

  Future<void> checkPermissions() async{
    alarmStatus = await Permission.scheduleExactAlarm.status;
    alertWindowStatus = await Permission.systemAlertWindow.status;
    notificationStatus = await Permission.notification.status;
    notifyListeners();
  }
}