import 'dart:async';

import 'task.dart';

class LocalDataSource {
  final provider = TaskProvider();

  Future<Task> insert(Task task) => provider.insert(task);

  Future<Task> get(int id) => provider.get(id);

  Future<List<Task>> getAll() => provider.getAll();

  Future<int> delete(int id) => provider.delete(id);

  Future<int> clearCompleted() => provider.clearCompleted();

  Future<int> update(Task task) => provider.update(task);
}
