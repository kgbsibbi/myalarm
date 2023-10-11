import 'package:flutter/material.dart';
import 'package:myalarm/provider/permission_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


class MyPermissionPage extends StatelessWidget{
  const MyPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PermissionProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Alarm'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
        body:Center(
          child:
          provider.allGranted ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                ElevatedButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/home');
                },child: const Text('시작하기'),),
              ]
              ): Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('권한 신청이 필요합니다.'),
                const SizedBox(width:10, height: 20,),
                if(provider.alarmStatus != PermissionStatus.granted)...[
                  ElevatedButton(
                    onPressed: (){
                      provider.requestAlarmPermission();
                    },
                    child: const Text('알람 설정 권한'))
                ],
                if(provider.alertWindowStatus != PermissionStatus.granted)...[
                  ElevatedButton(
                      onPressed: (){
                        provider.requestAlertWindowPermission();
                      },
                      child: const Text('시스템 창 권한'))
                ],
                if(provider.notificationStatus != PermissionStatus.granted)...[
                  ElevatedButton(
                      onPressed: (){
                        provider.requestNotificationPermission();
                      },
                      child: const Text('알림 보내기 권한'))
                ]
              ],
            )
          )
    );
  }
}