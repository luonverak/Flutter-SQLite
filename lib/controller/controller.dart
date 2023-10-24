import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../model/person.dart';

class PersonController {
  // connection and table
  String table = 'person';
  Future<Database> initializeData() async {
    Directory temDir = await getTemporaryDirectory();
    String temPath = temDir.path;
    Directory appDir = await getApplicationDocumentsDirectory();
    String appPath = appDir.path;
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'data.db'),
      version: 1,
      onCreate: (db, version) async {
        // create table
        await db.execute(
          'CREATE TABLE $table (id INTEGER PRIMARY KEY, name TEXT ,sex TEXT , age INTEGER ,image TEXT)',
        );
      },
    );
  }

  Future<void> insertData(Person person) async {
    final db = await initializeData();
    await db.insert(table, person.fromJson());
    print('success');
  }

  Future<List<Person>> getPersonData() async {
    final db = await initializeData();
    List<Map<String, dynamic>> result = await db.query(table);
    return result.map((e) => Person.toJson(e)).toList();
  }
}
