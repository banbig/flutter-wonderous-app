import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('photos.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE photos (
            id TEXT PRIMARY KEY,
            url TEXT,
            name TEXT,
            size REAL,
            dateTimeOriginal TEXT,
            latitude REAL,
            longitude REAL,
            clarity REAL,
            exposure REAL,
            faces INTEGER,
            composition REAL,
            colorfulness REAL,
            recommendationScore REAL,
            isBestCandidate INTEGER,
            groupId TEXT
          )
        ''');
      },
    );
  }
} 