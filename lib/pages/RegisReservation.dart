import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Regisreservation extends StatefulWidget {
  final campus;
  const Regisreservation({super.key, required this.campus});

  @override
  State<Regisreservation> createState() => _RegisreservationState();
}

class _RegisreservationState extends State<Regisreservation> {
  DateTime selectedDate = DateTime.now();
  List<String> timeSlots = [
    '09:00 - 11:00',
    '11:00 - 13:00',
    '13:00 - 15:00',
    '15:00 - 17:00',
  ];
  String? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
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

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // รูป
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.campus["image"],
                width: 300,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            // วันที่
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

            // Time Slot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Start Time - End"),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedTime,
                    hint: Text('Choose your time'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items:
                        timeSlots.map((slot) {
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

            // ปุ่ม Confirm
            ElevatedButton(
              onPressed: () {
                // จะเอาไปทำอะไรต่อ เช่นบันทึกลง DB หรือ print ค่า
                if (selectedTime != null) {
                  print(
                    'Booked: ${widget.campus["name"]} on ${DateFormat('dd/MM/yyyy').format(selectedDate)} at $selectedTime',
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select time slot")),
                  );
                }
              },
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

      // Bottom Navigation
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
