import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/data/localdatasource.dart';
import 'package:todo/data/task.dart';

class StatisticsFragment extends StatelessWidget {
  Future<List<Task>> load() async {
    return LocalDataSource().getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(),
      builder: (context, snapshot) {
        var activeSize = 0;
        var completedSize = 0;
        if (snapshot.hasData) {
          List<Task> tasks = snapshot.data;
          activeSize = tasks.where((task) => !task.completed).length;
          completedSize = tasks.where((task) => task.completed).length;
        }
        return Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Active tasks:$activeSize",
                  style: Theme.of(context).textTheme.subhead),
              Text("Completed tasks:$completedSize",
                  style: Theme.of(context).textTheme.subhead),
            ],
          ),
        );
      },
    );
  }
}
