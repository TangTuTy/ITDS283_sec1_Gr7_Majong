import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/pages/Homepage.dart';
import 'package:myapp/pages/profile.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final reserveSnap =
          await FirebaseFirestore.instance
              .collection('reserves')
              .where('creator', isEqualTo: uid)
              .orderBy('start_time', descending: true)
              .get();

      if (reserveSnap.docs.isEmpty) {
        setState(() {
          bookings = [];
          isLoading = false;
        });
        return;
      }

      List<Map<String, dynamic>> results = [];

      for (var doc in reserveSnap.docs) {
        final data = doc.data();
        final campusId = data['campusid'];

        final campusDoc =
            await FirebaseFirestore.instance
                .collection('campus')
                .doc(campusId)
                .get();

        final campusData = campusDoc.data();
        if (campusData != null) {
          results.add({
            'start_time': data['start_time'],
            'end_time': data['end_time'],
            'campus_name': campusData['name'],
            'campus_location': campusData['location-detail'],
            'campus_photo': campusData['photo'],
            'reserve_id': doc.id, // สำหรับลบ
          });
        }
      }

      setState(() {
        bookings = results;
        isLoading = false;
      });
    } catch (e) {
      print("🔥 ERROR: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> cancelBooking(String reserveId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reserves')
          .doc(reserveId)
          .delete();

      setState(() {
        bookings.removeWhere((booking) => booking['reserve_id'] == reserveId);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ยกเลิกการจองสำเร็จ')));
    } catch (e) {
      print("❌ Error cancelling booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการยกเลิก')),
      );
    }
  }

  String formatDate(Timestamp timestamp) {
    final dt = timestamp.toDate();
    return DateFormat('dd MMM yyyy HH:mm', 'th').format(dt);
  }

  void navigateToHomepage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  void navigateToprofile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Profilepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : bookings.isEmpty
              ? const Center(child: Text("ไม่พบการจอง"))
              : ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final item = bookings[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // รูปและชื่อ
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    item['campus_photo'],
                                    width: 120,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['campus_name'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['campus_location'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // วันที่และเวลา
                            Text(
                              "Booking date ${DateFormat('dd/MM/yyyy').format(item['start_time'].toDate())}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              "Time ${DateFormat('HH:mm').format(item['start_time'].toDate())} - ${DateFormat('HH:mm').format(item['end_time'].toDate())}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 8),
                            // confirmed และ cancel
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "confirmed",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text(
                                              'ยืนยันการยกเลิก',
                                            ),
                                            content: const Text(
                                              'คุณต้องการยกเลิกการจองนี้หรือไม่?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                                child: const Text('ยกเลิก'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  cancelBooking(
                                                    item['reserve_id'],
                                                  );
                                                },
                                                child: const Text(
                                                  'ยืนยัน',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    "cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF9DE1DB),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () => navigateToHomepage(context),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => navigateToHomepage(context),
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/logo.png'),
              ),
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
    );
  }
}
