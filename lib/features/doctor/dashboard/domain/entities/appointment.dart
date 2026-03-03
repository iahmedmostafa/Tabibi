class Appointment {
  final String id;
  final String patientName;
  final String patientId;
  final String time;
  final String date;
  final String type;
  final bool isUpcoming;
  final String location;
  final String lastVisit;
  final String allergies;
  final String medications;

  Appointment({
    this.id = '1',
    required this.patientName,
    this.patientId = '#PAT-2847',
    required this.time,
    required this.date,
    required this.type,
    this.isUpcoming = true,
    this.location = 'Medical Center, Room 204',
    this.lastVisit = 'Oct 15, 2025',
    this.allergies = 'Penicillin',
    this.medications = '2 Active',
  });
}
