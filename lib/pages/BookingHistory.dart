import 'package:flutter/material.dart';
import 'package:myapp/pages/Homepage.dart'; // Import หน้า Homepage

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  void navigateToHomepage(BuildContext context) {
    // ใช้ Navigator.push เพื่อไปหน้า Homepage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: const Color(0xFF397D75),
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ปุ่ม back
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  // โลโก้ + ข้อความ
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(width: 12),
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
                        'มาจอง',
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

      // BottomNavigationBar แบบที่มีโลโก้ตรงกลาง
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF9DE1DB),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed:
                  () =>
                      navigateToHomepage(context), // เปลี่ยนเป็นไปหน้า Homepage
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap:
                  () => navigateToHomepage(
                    context,
                  ), // เมื่อคลิกโลโก้ก็ไปหน้า Homepage
              child: CircleAvatar(
                radius: 20, // ขนาดของ CircleAvatar
                backgroundImage: AssetImage('assets/logo.png'),
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
