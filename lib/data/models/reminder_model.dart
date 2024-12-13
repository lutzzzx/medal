class ReminderModel {
  String id;
  String userId;
  String medicineName;
  int dailyConsumption;
  int doses;
  String medicineType;
  String medicineUse;
  int supply;
  String notes;
  List<String> times;
  Map<String, bool> status;
  String date;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.medicineName,
    required this.dailyConsumption,
    required this.doses,
    required this.medicineType,
    required this.medicineUse,
    required this.supply,
    required this.notes,
    required this.times,
    required this.status,
    required this.date,
  });

  // copyWith method
  ReminderModel copyWith({
    String? id,
    String? userId,
    String? medicineName,
    int? dailyConsumption,
    int? doses,
    String? medicineType,
    String? medicineUse,
    int? supply,
    String? notes,
    List<String>? times,
    Map<String, bool>? status,
    String? date,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      medicineName: medicineName ?? this.medicineName,
      dailyConsumption: dailyConsumption ?? this.dailyConsumption,
      doses: doses ?? this.doses,
      medicineType: medicineType ?? this.medicineType,
      medicineUse: medicineUse ?? this.medicineUse,
      supply: supply ?? this.supply,
      notes: notes ?? this.notes,
      times: times ?? this.times,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }

  factory ReminderModel.fromMap(Map<String, dynamic> data, String id) {
    return ReminderModel(
      id: id,
      userId: data['userId'],
      medicineName: data['medicineName'],
      dailyConsumption: data['dailyConsumption'],
      doses: data['doses'],
      medicineType: data['medicineType'],
      medicineUse: data['medicineUse'],
      supply: data['supply'],
      notes: data['notes'],
      times: List<String>.from(data['times']),
      status: Map<String, bool>.from(data['status']),
      date: data['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'medicineName': medicineName,
      'dailyConsumption': dailyConsumption,
      'doses': doses,
      'medicineType': medicineType,
      'medicineUse': medicineUse,
      'supply': supply,
      'notes': notes,
      'times': times,
      'status': status,
      'date': date,
    };
  }
}
