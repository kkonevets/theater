abstract class Record {
  int id;
  String name;
  DateTime time;
  String tableName;

  Record({this.id, this.name, this.time, this.tableName});

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

class Client extends Record {
  int sessionId;
  String barcode;
  String phoneNumber;
  int seatNumber;
  bool isPresent;

  Client(
      {String name,
      this.barcode,
      this.phoneNumber,
      DateTime time,
      this.seatNumber,
      this.isPresent = false})
      : super(name: name, time: time, tableName: "clients");

  @override
  Client.fromMap(Map<String, dynamic> map)
      : sessionId = map['sessionId'],
        barcode = map['barcode'],
        phoneNumber = map['phoneNumber'],
        seatNumber = map['seatNumber'],
        isPresent = map['isPresent'],
        super(
            id: map["_id"],
            name: map['name'],
            time: DateTime.fromMicrosecondsSinceEpoch(map['time']),
            tableName: "clients");

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

class Session extends Record {
  int totalSeats;

  Session({String name, DateTime time, this.totalSeats})
      : super(name: name, time: time, tableName: "sessions");

  @override
  Session.fromMap(Map<String, dynamic> map)
      : totalSeats = map['totalSeats'],
        super(
            id: map["_id"],
            name: map['name'],
            time: DateTime.fromMicrosecondsSinceEpoch(map['time']),
            tableName: "sessions");

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
