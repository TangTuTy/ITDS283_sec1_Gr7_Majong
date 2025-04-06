// pages/contact_insert_page.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContactInsertPage extends StatefulWidget {
  final Database database;
  const ContactInsertPage({super.key, required this.database});

  @override
  State<ContactInsertPage> createState() => _ContactInsertPageState();
}

class _ContactInsertPageState extends State<ContactInsertPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _insertContact() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    if (name.isNotEmpty && phone.isNotEmpty) {
      await widget.database.rawInsert(
        'INSERT INTO contacts (name, phone) VALUES (?, ?)',
        [name, phone],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลเรียบร้อยแล้ว')),
      );
      _nameController.clear();
      _phoneController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มผู้ติดต่อ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'ชื่อ'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'เบอร์โทร'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _insertContact,
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
