import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Regisreservation extends StatefulWidget {
  final campus;
  final campusid;
  const Regisreservation({
    super.key,
    required this.campus,
    required this.campusid,
  });

  @override
  State<Regisreservation> createState() => _RegisreservationState();
}

class _RegisreservationState extends State<Regisreservation> {
  late DateTime selectedDate;
  List<String> timeSlots = [];
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    bool isSundayClosed = widget.campus["time"].contains("ปิดวันอาทิตย์");
    DateTime now = DateTime.now();
    if (isSundayClosed && now.weekday == DateTime.sunday) {
      selectedDate = now.add(const Duration(days: 1));
    } else {
      selectedDate = now;
    }

    loadAvailableTimeSlots();
  }

  List<String> generateTimeSlotsFromText(String text) {
    final RegExp regex = RegExp(r'(\d{1,2}:\d{2})[–-](\d{1,2}:\d{2})');
    final match = regex.firstMatch(text);

    if (match == null) return [];

    final start = match.group(1)!;
    final end = match.group(2)!;

    final startParts = start.split(':').map(int.parse).toList();
    final endParts = end.split(':').map(int.parse).toList();

    DateTime current = DateTime(0, 1, 1, startParts[0], startParts[1]);
    DateTime endTime = DateTime(0, 1, 1, endParts[0], endParts[1]);

    List<String> slots = [];
    const Duration slotDuration = Duration(hours: 2);

    while (current.add(slotDuration).isBefore(endTime) ||
        current.add(slotDuration).isAtSameMomentAs(endTime)) {
      final next = current.add(slotDuration);
      final formatted =
          "${current.hour.toString().padLeft(2, '0')}:${current.minute.toString().padLeft(2, '0')} - "
          "${next.hour.toString().padLeft(2, '0')}:${next.minute.toString().padLeft(2, '0')}";
      slots.add(formatted);
      current = next;
    }

    return slots;
  }

  Future<void> loadAvailableTimeSlots() async {
    List<String> allSlots = generateTimeSlotsFromText(widget.campus["time"]);

    DateTime dayStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      0,
      0,
    );
    DateTime dayEnd = dayStart.add(const Duration(days: 1));

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('reserves')
            .where('campusid', isEqualTo: widget.campusid)
            .where(
              'start_time',
              isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart),
            )
            .where('start_time', isLessThan: Timestamp.fromDate(dayEnd))
            .get();

    List<DocumentSnapshot> reservedDocs = snapshot.docs;

    List<Map<String, DateTime>> reservedSlots =
        reservedDocs.map((doc) {
          return {
            'start': (doc['start_time'] as Timestamp).toDate(),
            'end': (doc['end_time'] as Timestamp).toDate(),
          };
        }).toList();

    List<String> available =
        allSlots.where((slot) {
          final times = slot.split(' - ');
          final start = times[0].split(':').map(int.parse).toList();
          final end = times[1].split(':').map(int.parse).toList();

          final slotStart = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            start[0],
            start[1],
          );
          final slotEnd = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            end[0],
            end[1],
          );

          for (var r in reservedSlots) {
            if (slotStart.isBefore(r['end']!) && slotEnd.isAfter(r['start']!)) {
              return false;
            }
          }
          return true;
        }).toList();

    setState(() {
      timeSlots = available;
      selectedTime = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    bool isSundayClosed = widget.campus["time"].contains("ปิดวันอาทิตย์");
    DateTime initDate = selectedDate;
    if (isSundayClosed && selectedDate.weekday == DateTime.sunday) {
      initDate = selectedDate.add(const Duration(days: 1));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime day) {
        if (isSundayClosed) {
          return day.weekday != DateTime.sunday;
        }
        return true;
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      await loadAvailableTimeSlots();
    }
  }

  Future<void> reservePlace() async {
    if (selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select time slot")));
      return;
    }

    try {
      final times = selectedTime!.split(' - ');
      final startTimeParts = times[0].split(':');
      final endTimeParts = times[1].split(':');

      final DateTime startDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(startTimeParts[0]),
        int.parse(startTimeParts[1]),
      );
      final DateTime endDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(endTimeParts[0]),
        int.parse(endTimeParts[1]),
      );

      await FirebaseFirestore.instance.collection('reserves').add({
        'creator': FirebaseAuth.instance.currentUser?.uid,
        'campusid': widget.campusid,
        'start_time': Timestamp.fromDate(startDateTime),
        'end_time': Timestamp.fromDate(endDateTime),
        'created_at': Timestamp.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("จองสำเร็จ!")));
      Navigator.pop(context);
    } catch (e) {
      print("Error booking: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("เกิดข้อผิดพลาดในการจอง")));
    }
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.campus["photo"],
                width: 300,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Date"),
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: DateFormat('dd/MM/yyyy').format(selectedDate),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Start Time - End"),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedTime,
                    hint: const Text('Choose your time'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items:
                        timeSlots.isEmpty
                            ? [
                              const DropdownMenuItem(
                                value: null,
                                child: Text("ไม่มีเวลาว่าง"),
                              ),
                            ]
                            : timeSlots.map((slot) {
                              return DropdownMenuItem(
                                value: slot,
                                child: Text(slot),
                              );
                            }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: reservePlace,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF57A89A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Confirm", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF9DE1DB),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () => Navigator.pop(context),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                radius: 20,
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
