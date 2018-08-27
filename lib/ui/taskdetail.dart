import 'package:flutter/material.dart';
import 'package:todo/data/localdatasource.dart';
import 'package:todo/data/task.dart';
import 'package:todo/ui/addedittask.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  TaskDetailPage(this.task);

  @override
  State<StatefulWidget> createState() {
    return _TaskDetailPageState();
  }
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TaskDetail"),
        actions: <Widget>[
          IconButton(
            tooltip: "Delete",
            icon: Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            onPressed: () async {
              await LocalDataSource().delete(widget.task.id);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: ListTile(
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
            }),
        title: Text(widget.task.title),
        subtitle: widget.task.description != null
            ? Text(widget.task.description)
            : null,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddEditTaskPage(widget.task)));
        },
      ),
    );
  }
}
