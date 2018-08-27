import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/data/localdatasource.dart';
import 'package:todo/data/task.dart';
import 'package:todo/ui/taskdetail.dart';

class TasksFragment extends StatefulWidget {
  TasksFragment({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TasksFragmentState();
  }
}

const FILTER_ALL = 0;
const FILTER_ACTIVE = 1;
const FILTER_COMPLETED = 2;

class TasksFragmentState extends State<TasksFragment> {
  final List<Task> _data = [];
  final List<Task> _showData = [];

  var _currentFilter = FILTER_ALL;

  var _dataSource = LocalDataSource();

  // Used to build list items that haven't been removed.
  Widget _buildItem(Task task) => _ListItem(task);

  String _getFilterTitle() {
    switch (_currentFilter) {
      case FILTER_ACTIVE:
        return "Active TO-DOs";
      case FILTER_COMPLETED:
        return "Completed TO-DOs";
      case FILTER_ALL:
      default:
        return "All TO-DOs";
    }
  }

  bool _getFilterCondition(Task task) {
    switch (_currentFilter) {
      case FILTER_ACTIVE:
        return !task.completed;
      case FILTER_COMPLETED:
        return task.completed;
      case FILTER_ALL:
      default:
        return true;
    }
  }

  String _getEmptyText() {
    switch (_currentFilter) {
      case FILTER_ACTIVE:
        return "You have no active TO-DOs!";
      case FILTER_COMPLETED:
        return "You have no completed TO-DOs!";
      case FILTER_ALL:
      default:
        return "You have no TO-DOs!";
    }
  }

  IconData _getEmptyIconData() {
    switch (_currentFilter) {
      case FILTER_ACTIVE:
        return Icons.check_circle;
      case FILTER_COMPLETED:
        return Icons.verified_user;
      case FILTER_ALL:
      default:
        return Icons.assignment_turned_in;
    }
  }

  setFilter(int filter) {
    setState(() => _currentFilter = filter);
  }

  Future<Null> refresh() async {
    var data = await _dataSource.getAll();
    setState(() {
      _data.clear();
      _data.addAll(data);
      _showData.clear();
      _showData.addAll(data.where((task) => _getFilterCondition(task)));
    });
    return null;
  }

  Future<Null> clearCompleted() async {
    await _dataSource.clearCompleted();
    return await refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: refresh(),
      builder: (context, snapshot) {
        return RefreshIndicator(
          child: _showData.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      _getEmptyIconData(),
                      color: Colors.grey[600],
                      size: 48.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        _getEmptyText(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: _currentFilter == FILTER_ALL ? 24.0 : 0.0),
                      child: _currentFilter == FILTER_ALL
                          ? Text(
                              "add a TO-DO item +",
                              style: TextStyle(color: Colors.grey[600]),
                            )
                          : null,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        _getFilterTitle(),
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, index) => _buildItem(_showData[index]),
                        itemCount: _showData.length,
                      ),
                    ),
                  ],
                ),
          onRefresh: () => refresh(),
        );
      },
    );
  }
}

class _ListItem extends StatefulWidget {
  final Task task;

  _ListItem(this.task);

  @override
  State<StatefulWidget> createState() {
    return _ListItemState();
  }
}

class _ListItemState extends State<_ListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.task.completed ? Colors.grey[400] : Colors.transparent,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TaskDetailPage(widget.task)));
        },
        leading: Checkbox(
          value: widget.task.completed,
          onChanged: (checked) async {
            setState(() {
              widget.task.completed = checked;
            });
            try {
              await LocalDataSource().update(widget.task);
            } catch (e) {
              setState(() {
                widget.task.completed = !checked;
              });
            }
          },
        ),
        title: Text(widget.task.title),
      ),
    );
  }
}
