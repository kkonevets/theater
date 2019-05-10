import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:theater/models.dart';

class DatabaseHelper {
  static final _databaseName = "theater.db";
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    db.execute(
      """
        CREATE TABLE sessions(
          id INTEGER PRIMARY KEY, 
          name TEXT,
          time INTEGER,
          totalSeats INTEGER
        )
      """,
    );

    db.execute(
      """
        CREATE TABLE clients(
          id INTEGER PRIMARY KEY,
          sessionId INTEGER,
          name TEXT, 
          barcode TEXT,
          phoneNumber TEXT,
          time INTEGER,
          seatNumber INTEGER,
          isPresent INTEGER
        )
      """,
    );
  }

  Future<List<Record>> getAll(String tableName,
      {List<String> columns, int sessionId}) async {
    final Database db = await database;

    List<Map<String, dynamic>> result;
    if (sessionId != null) {
      result = await db.query(tableName,
          columns: columns, where: 'sessionId = ?', whereArgs: [sessionId]);
    } else {
      result = await db.query(tableName, columns: columns);
    }

    List<Record> items = result.isNotEmpty
        ? result.map((item) => Record.fromMap(item, tableName)).toList()
        : [];
    return items;
  }

  Future<int> insert(Record rec) async {
    final Database db = await database;

    int id = await db.insert(rec.tableName, rec.toMap());
    return id;
  }

  Future<int> update(Record rec) async {
    final db = await database;

    var result = await db.update(rec.tableName, rec.toMap(),
        where: "id = ?", whereArgs: [rec.id]);

    return result;
  }

  Future<int> delete(Record rec) async {
    final db = await database;
    var result =
        await db.delete(rec.tableName, where: 'id = ?', whereArgs: [rec.id]);

    return result;
  }

  Future<Record> read(String tableName, int id) async {
    final Database db = await database;

    List<Map> maps = await db
        .query(tableName, columns: null, where: '_id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Record.fromMap(maps.first, tableName);
    }
    return null;
  }
}
