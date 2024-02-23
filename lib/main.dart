
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:thakeren/Pages/TopBar.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox("Location"); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TopBar(),
    );
  }
}
