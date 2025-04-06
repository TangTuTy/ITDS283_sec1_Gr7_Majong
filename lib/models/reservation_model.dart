// lib/models/reservation_model.dart

class ReservationModel {
  final String image;
  final String campus;
  final String location;

  ReservationModel({
    required this.image,
    required this.campus,
    required this.location,
  });

  // ฟังก์ชันแปลงจาก Map (จากฐานข้อมูล) เป็น ReservationModel
  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      image: map['image'],
      campus: map['campus'],
      location: map['location'],
    );
  }

  // ฟังก์ชันแปลงจาก ReservationModel เป็น Map (สำหรับการแทรกข้อมูลลงในฐานข้อมูล)
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'campus': campus,
      'location': location,
    };
  }
}
