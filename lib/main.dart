import 'package:flutter/material.dart';

import 'package:myalarm/permission_page.dart';
import 'package:myalarm/home_page.dart';
import 'package:myalarm/provider/alarm_provider.dart';
import 'package:myalarm/provider/permission_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> PermissionProvider()),
        ChangeNotifierProvider(create: (context)=> AlarmProvider())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/home': (context) => const MyHomePage(),
        '/permission':(context) => const MyPermissionPage()},
      initialRoute: '/permission',
    );
  }
}


