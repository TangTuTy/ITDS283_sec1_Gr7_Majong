import 'package:flutter/material.dart';
import 'package:myapp/pages/Homepage.dart';

void main() {
  runApp(const MaChongApp());
}

class MaChongApp extends StatelessWidget {
  const MaChongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as p;
// import 'package:sqflite/sqflite.dart';
// import 'package:myapp/pages/InserDB.dart';


// void main() {
//   runApp(const ContactsApp());
// }

// class ContactsApp extends StatelessWidget {
//   const ContactsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Contacts CRUD Navigator',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Database? _db;

//   @override
//   void initState() {
//     super.initState();
//     _initDatabase();
//   }

//   Future<void> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final path = p.join(dbPath, 'contacts_map.db');
//     _db = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//         CREATE TABLE contacts (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         phone TEXT)
//         ''');
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Contacts CRUD Navigator')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
            
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ContactInsertPage(database: _db!),
//                   ),
//                 );
//               },
//               child: const Text('➕ เพิ่มผู้ติดต่อ (CREATE)'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


