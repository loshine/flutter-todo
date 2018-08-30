import 'package:flutter/material.dart';
import 'package:todo/data/localdatasource.dart';
import 'package:todo/data/task.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task task;

  AddEditTaskPage(this.task);

  @override
  State<StatefulWidget> createState() {
    return _AddEditTaskPageState();
  }
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  _maybeSave(BuildContext context) async {
    if (widget.task.title == null || widget.task.title.isEmpty) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Title must not be empty.')));
    } else {
      var dataSource = LocalDataSource();
      if (widget.task.id != null) {
        await dataSource.update(widget.task);
      } else {
        await dataSource.insert(widget.task);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AddEditTask"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              style: Theme.of(context).textTheme.title,
              decoration: InputDecoration(hintText: 'Title'),
              onChanged: (text) => widget.task.title = text,
              controller: TextEditingController(text: widget.task.title),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 12,
              style: Theme.of(context).textTheme.subhead,
              decoration: InputDecoration(hintText: 'Enter your TO-DO here.'),
              onChanged: (text) => widget.task.description = text,
              controller: TextEditingController(text: widget.task.description),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          tooltip: 'Finish',
          child: Icon(Icons.check),
          onPressed: () => _maybeSave(context),
        );
      }),
    );
  }
}
