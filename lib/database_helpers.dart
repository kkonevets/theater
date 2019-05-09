import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class Record {
  String tableName;

  Record();

  factory Record.fromMap(Map<String, dynamic> map, String tableName) {
    switch (tableName) {
      case 'session':
        return Session.fromMap(map);
      case 'client':
        return Client.fromMap(map);
      default:
        return null;
    }
  }

  Map<String, dynamic> toMap();
}

class Session extends Record {
  final String tableName = 'sessions';

  Session({this.name, this.time, this.totalSeats}) : super();

  int id;
  String name;
  DateTime time;
  int totalSeats;

  @override
  Session.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        name = map['name'],
        time = DateTime.fromMicrosecondsSinceEpoch(map['time']),
        totalSeats = map['totalSeats'];

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'time': time.millisecondsSinceEpoch,
      'totalSeats': totalSeats,
    };
    if (id != null) {
      map['_id'] = id;
    }
    return map;
  }
}

class Client extends Record {
  final String tableName = 'clients';

  Client(
      {this.name,
      this.barcode,
      this.phoneNumber,
      this.time,
      this.seatNumber,
      this.isPresent})
      : super();

  int id;
  int sessionId;
  String name;
  String barcode;
  String phoneNumber;
  DateTime time;
  int seatNumber;
  bool isPresent;

  @override
  Client.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        sessionId = map['sessionId'],
        name = map['name'],
        barcode = map['barcode'],
        phoneNumber = map['phoneNumber'],
        time = DateTime.fromMicrosecondsSinceEpoch(map['time']),
        seatNumber = map['seatNumber'],
        isPresent = map['isPresent'];

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'barcode': barcode,
      'phoneNumber': phoneNumber,
      'time': time.millisecondsSinceEpoch,
      'seatNumber': seatNumber,
      'isPresent': isPresent
    };
    if (id != null) {
      map['_id'] = id;
    }
    if (sessionId != null) {
      map['sessionId'] = sessionId;
    }
    return map;
  }
}

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

  Future<int> insert(Record rec) async {
    Database db = await database;

    int id = await db.insert(rec.tableName, rec.toMap());
    return id;
  }

  Future<Record> queryRecord(String tableName, int id) async {
    Database db = await database;

    List<Map> maps = await db
        .query(tableName, columns: null, where: '_id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Record.fromMap(maps.first, tableName);
    }
    return null;
  }
}
