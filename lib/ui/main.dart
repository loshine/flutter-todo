import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo/ui/addedittask.dart';
import 'package:todo/ui/home.dart';
import 'package:todo/ui/taskdetail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.red,
      ),
      home: MyHomePage(title: 'TO-DOs'),
    );
  }
}
