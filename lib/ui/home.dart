import 'package:flutter/material.dart';
import 'package:todo/data/task.dart';
import 'package:todo/ui/addedittask.dart';
import 'package:todo/ui/statistics.dart';
import 'package:todo/ui/tasks.dart';

final tasksKey = GlobalKey<TasksFragmentState>();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _fragments = [TasksFragment(key: tasksKey), StatisticsFragment()];
  FloatingActionButton _fab;
  List<Widget> _appBarActions;
  var _selectedIndex = 0;

  _setSelection(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  FloatingActionButton _getFabByIndex() {
    return _selectedIndex == 0 ? _fab : null;
  }

  List<Widget> _getActionsByIndex() {
    return _selectedIndex == 0 ? _appBarActions : null;
  }

  @override
  void initState() {
    super.initState();
    _fab = FloatingActionButton(
      onPressed: () {
        Navigator
            .of(context)
            .push(MaterialPageRoute(builder: (_) => AddEditTaskPage(Task())));
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
    _appBarActions = <Widget>[
      PopupMenuButton<int>(
        icon: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
        onSelected: (i) => tasksKey.currentState.setFilter(i),
        itemBuilder: (context) {
          return <PopupMenuEntry<int>>[
            PopupMenuItem(value: FILTER_ALL, child: Text("All")),
            PopupMenuItem(value: FILTER_ACTIVE, child: Text("Active")),
            PopupMenuItem(value: FILTER_COMPLETED, child: Text("Completed")),
          ];
        },
      ),
      PopupMenuButton<int>(
        onSelected: (i) async {
          switch (i) {
            case 0:
              await tasksKey.currentState.clearCompleted();
              break;
            case 1:
              await tasksKey.currentState.refresh();
              break;
          }
        },
        itemBuilder: (context) {
          return <PopupMenuEntry<int>>[
            PopupMenuItem(value: 0, child: Text("Clear completed")),
            PopupMenuItem(value: 1, child: Text("Refresh")),
          ];
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: _getActionsByIndex(),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 240.0,
              width: double.infinity,
              color: Colors.teal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/images/logo.png"),
                    width: 100.0,
                    height: 100.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "TO-DOs",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.format_list_bulleted,
                    ),
                    title: Text(
                      "TO-DO List",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _setSelection(0);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.assessment,
                    ),
                    title: Text(
                      "Statistics",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _setSelection(1);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: _fragments[_selectedIndex],
      floatingActionButton: _getFabByIndex(),
    );
  }
}
