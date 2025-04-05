import 'package:flutter/material.dart';
import 'package:myapp/pages/Homepage.dart'; // Import หน้า Homepage

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  void navigateToHomepage(BuildContext context) {
    // ใช้ Navigator.push เพื่อไปหน้า Homepage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFF397D75),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // ปุ่มย้อนกลับ
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // เมื่อกดปุ่มนี้จะย้อนกลับไปหน้า Homepage
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 16),
                  // โลโก้
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ma Chong',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        'มาจอง',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // เพิ่มคอนเทนต์อื่นๆ ของ ReservationPage ที่นี่ เช่น ข้อความหรือปุ่มต่างๆ
          ],
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
              onPressed: () => navigateToHomepage(context), // เปลี่ยนเป็นไปหน้า Homepage
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => navigateToHomepage(context),  // เมื่อคลิกโลโก้ก็ไปหน้า Homepage
              child: CircleAvatar(
                radius: 20, // ขนาดของ CircleAvatar
                backgroundImage: AssetImage('assets/logo.png'),
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
