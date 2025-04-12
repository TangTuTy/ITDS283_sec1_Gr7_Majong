import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/pages/Homepage.dart';
import 'package:myapp/pages/login.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('th_TH', null);
  runApp(const MaChongApp());
}

class MaChongApp extends StatelessWidget {
  const MaChongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          FirebaseAuth.instance.currentUser == null ? LoginPage() : Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
