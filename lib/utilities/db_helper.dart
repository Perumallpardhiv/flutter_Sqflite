import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sql_todo/models/todo_model.dart';

final String tableName = 'todos';

class dbHelper {
  static final dbHelper instance = dbHelper._init();
  static Database? _database;
  dbHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('todo.db');
    return _database!;
  }

  //! all the below 20-35 lines takes place only when 'todo.db' named database is not in device path
  //? so, once after creating a database if we want to update that follow these steps:-
  //? -> beside of onCreate add onUpdate attribute and give _update function to it
  //? -> increase version number by adding one.

  Future<Database> _initDB(String filePath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createdb);
  }

  Future _createdb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tableName(id INTEGER NOT NULL PRIMARY KEY, number INTEGER NOT NULL, status BOOLEAN NOT NULL, title TEXT NOT NULL, description TEXT NOT NULL, date TEXT NOT NULL)',
    );
  }

  Future<void> create(todomodel todo) async {
    final db = await instance.database;
    //? some times we may need to create like a sql statement then we use "db.rawInsert" method else we can use "db.insert" method.
    // final json = todomodel.toJson();
    // final columns = '${todoFields.title}, ${todoFields.description}, ${todoFields.date}';
    // final values = '${json[todoFields.title]}, ${json[todoFields.description]}, ${json[todoFields.date]}';
    // final id = await db.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');  //? sql statement.
    await db.insert(tableName, todo.toMap());
  }

  // To read particular single ToDo.
  Future<todomodel> readTodo(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableName,
      // in below line we mention which columns we need to get by using this method.
      columns: ['id', 'number', 'title', 'description', 'status', 'date'],
      // below line is for finding the id we given in the attribute of method
      where: 'id = ?',
      whereArgs: [id],
      // no.of field inside square bracket = no.of question marks in where
    );

    if (maps.isNotEmpty) {
      return todomodel.fromMap(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  // To read multiple Todo's
  Future<List<todomodel>> readAllTodo() async {
    final db = await instance.database;
    final order = 'date ASC';

    //? some times we may need to read like a sql statement then we use "db.rawQuery" method else we can use "db.query" method.
    // final result = await db.rawQuery('SELECT * FROM $tableName ORDER BY $order');  //? sql statement.

    final result = await db.query(tableName, orderBy: order);

    return result.map((ele) => todomodel.fromMap(ele)).toList();
  }

  // update todomodel
  Future<void> update(todomodel todomodel) async {
    final db = await instance.database;

    //similar as above we can use rawUpdate if needed

    db.update(
      tableName,
      todomodel.toMap(),
      where: 'id = ?',
      whereArgs: [todomodel.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await instance.database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
