// นำเข้า packages ที่จำเป็น
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:myapp/pages/Reservation.dart';
import 'package:myapp/pages/BookingHistory.dart';
import 'package:myapp/pages/profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, dynamic>? latestBooking;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLatestBooking();
  }

  Future<void> fetchLatestBooking() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final reserveSnap =
          await FirebaseFirestore.instance
              .collection('reserves')
              .where('creator', isEqualTo: uid)
              .orderBy('start_time', descending: true)
              .limit(1)
              .get();

      if (reserveSnap.docs.isEmpty) {
        setState(() {
          latestBooking = null;
          isLoading = false;
        });
        return;
      }

      final data = reserveSnap.docs.first.data();
      final campusDoc =
          await FirebaseFirestore.instance
              .collection('campus')
              .doc(data['campusid'])
              .get();

      final campusData = campusDoc.data();
      if (campusData != null) {
        setState(() {
          latestBooking = {
            'start_time': data['start_time'],
            'end_time': data['end_time'],
            'campus_name': campusData['name'],
            'campus_location': campusData['location-detail'],
            'campus_photo': campusData['photo'],
          };
          isLoading = false;
        });
      }
    } catch (e) {
      print("🔥 ERROR: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToReservation(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationPage()),
    );
    fetchLatestBooking();
  }

  void navigateToBookingHistory(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookingHistoryPage()),
    );
    // โหลดใหม่เมื่อกลับมา
    fetchLatestBooking();
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
      backgroundColor: Colors.white,
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
              radius: 20,
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
            // ปุ่ม Reserve และ Booking History
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
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'assets/room.png',
                                  width: 130,
                                  height: 130,
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
                  GestureDetector(
                    onTap: () => navigateToBookingHistory(context),
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
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/calendar.png',
                            width: 130,
                            height: 130,
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
            ),

            const SizedBox(height: 16),

            if (isLoading)
              const CircularProgressIndicator()
            else if (latestBooking != null) ...[
              ElevatedButton(
                onPressed: () => navigateToBookingHistory(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAEA9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Recent Reservation',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.asset(
                          latestBooking!['campus_photo'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              latestBooking!['campus_name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(latestBooking!['campus_location']),
                            const SizedBox(height: 8),
                            Text(
                              "Date : ${DateFormat('dd/MM/yyyy').format(latestBooking!['start_time'].toDate())}",
                            ),
                            Text(
                              "Time : ${DateFormat('HH.mm').format(latestBooking!['start_time'].toDate())} - ${DateFormat('HH.mm').format(latestBooking!['end_time'].toDate())}",
                            ),
                            Text("Branch : ${latestBooking!['campus_name']}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
