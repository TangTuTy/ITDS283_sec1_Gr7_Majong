// lib/database_helper.dart

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:myapp/models/reservation_model.dart';

class DatabaseHelper {
  static const _databaseName = "reservation.db";
  static const _databaseVersion = 1;

  static const table = 'reservations';

  static const columnId = '_id';
  static const columnImage = 'image';
  static const columnCampus = 'campus';
  static const columnLocation = 'location';

  static Database? _database;

  // ฟังก์ชันในการเปิดฐานข้อมูล
  Future<Database> get database async {
    if (_database != null) return _database!;

    // หากฐานข้อมูลยังไม่เปิด จะทำการเปิดใหม่
    _database = await _initDatabase();
    return _database!;
  }

  // ฟังก์ชันในการสร้างฐานข้อมูล
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // ฟังก์ชันสร้างตารางเมื่อฐานข้อมูลถูกสร้างครั้งแรก
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnImage TEXT NOT NULL,
        $columnCampus TEXT NOT NULL,
        $columnLocation TEXT NOT NULL
      )
    ''');
  }

  // ฟังก์ชันเพิ่มข้อมูลลงในฐานข้อมูล
  Future<int> insertData(ReservationModel reservation) async {
    Database db = await database;  // ใช้ await เพื่อรอการเปิดฐานข้อมูล
    return await db.insert(table, reservation.toMap());
  }

  // ฟังก์ชันดึงข้อมูลทั้งหมดจากฐานข้อมูล
  Future<List<ReservationModel>> getAllData() async {
    Database db = await database;  // ใช้ await เพื่อรอการเปิดฐานข้อมูล
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return ReservationModel.fromMap(maps[i]);
    });
  }
}
