import 'package:flutter/material.dart';
import 'package:myapp/pages/Reservation.dart';
import 'package:myapp/pages/BookingHistory.dart';
import 'package:myapp/pages/profile.dart';
import 'package:sqflite/sqflite.dart'; // เพิ่มการ import หน้า BookingHistory
import 'package:path/path.dart' as p;

//import 'package:myapp/pages/reservation_pageDB.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Database? _db;
  Database? _db2;
  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'campus.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE campus (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image TEXT,
        name TEXT,
        location TEXT
      )
      ''');
      },
    );

    // ✅ เช็คว่ามีข้อมูลใน table หรือยัง
    final countResult = await _db!.rawQuery(
      'SELECT COUNT(*) as count FROM campus',
    );
    final count = Sqflite.firstIntValue(countResult);

    if (count == 0) {
      // 🟢 ถ้ายังไม่มีข้อมูล ค่อย insert
      await _db?.rawInsert('''
      INSERT INTO campus (image, name, location)
      VALUES
        ('assets/mu/mu2.jpg', 'Mahidol campus', '999 ถ.พระราม 4 ต.ศาลายา อ.พุทธมณฑล จ.นครปฐม 73170'),
        ('assets/tu/tu2.jpeg', 'Thammasat campus', '99 หมู่ 18 ถ.พหลโยธิน ต.คลองหนึ่ง อ.คลองหลวง จ.ปทุมธานี 12120'),
        ('assets/ku/ku2.jpg', 'Kasetsart campus', '50 ถนนงามวงศ์วาน บางเขน เขตบางเขน กรุงเทพฯ 10900'),
        ('assets/cu/cu1.jpg', 'Chula campus', '254 ถนนพญาไท แขวงวังใหม่ เขตปทุมวัน กรุงเทพฯ 10330')
    ''');
    }

    final path2 = p.join(dbPath, 'reserved.db');
    _db2 = await openDatabase(
      path2,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE reserved (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        campus_id INTEGER,
        timestamp DATETIME,
        FOREIGN KEY (campus_id) REFERENCES Campus(id)
      )
      ''');
      },
    );
  }

  void navigateToReservation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationPage()),
    );
  }

  void navigateToBookingHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookingHistoryPage(),
      ), // เพิ่มการเชื่อมไปหน้า BookingHistory
    );
  }

  void navigateToprofile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Profilepage(),
      ), // เพิ่มการเชื่อมไปหน้า BookingHistory
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: const Color(0xFF397D75),
          automaticallyImplyLeading: false, // ไม่แสดงปุ่ม back โดยอัตโนมัติ
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ma Chong',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'information',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,

      // BottomNavigationBar แบบที่มีโลโก้ตรงกลาง
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF9DE1DB),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () => navigateToReservation(context),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 20, // ขนาดของ CircleAvatar
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => navigateToprofile(context),
            ),
            label: '',
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Reserve & History buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => navigateToReservation(context),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'assets/room.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Reserve a Room',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap:
                            () => navigateToBookingHistory(
                              context,
                            ), // เพิ่มการเชื่อมไปหน้า BookingHistory
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/calendar.png',
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Booking History',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
