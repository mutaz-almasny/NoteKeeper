import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDB {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  Future initialDB() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, "notes.db");
    Database notesDB = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onUpgrade: _onUpgrade,
    );

    return notesDB;
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute('''
  CREATE TABLE "notes" (id INTEGER
 NOT NULL PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  note TEXT NOT NULL
  )

''');
    await batch.commit();
    print("Create DB----------------");
  }

  Future readData(String sql) async {
    Database? myDB = await db;
    List<Map> response = await myDB!.rawQuery(sql);
    return response;
  }

  Future insertData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawInsert(sql);
    return response;
  }

  Future updateData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawUpdate(sql);
    return response;
  }

  Future deleteData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawDelete(sql);
    return response;
  }

  Future deleteMyDatabase() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, "notes.db");
    await deleteDatabase(path);
  }

  //##################################################

  Future read(String table) async {
    Database? myDB = await db;
    List<Map> response = await myDB!.query(table);
    return response;
  }

  Future insert(String table, Map<String, Object?> values) async {
    Database? myDB = await db;
    int response = await myDB!.insert(table,values);
    return response;
  }

  Future update(String table,Map<String, Object?> values, String? id) async {
    Database? myDB = await db;
    int response = await myDB!.update(table, values, where:  id);
    return response;
  }

  Future delete(String table, String? id ) async {
    Database? myDB = await db;
    int response = await myDB!.delete(table, where: id);
    return response;
  }

}
