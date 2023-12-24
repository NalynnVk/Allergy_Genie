import 'package:allergygenieapi/models/medication/medication_model.dart';

class MedReminder {
  // int? id;
  Medication? medication;
  int? dosage;
  String? time_reminder;
  // String? repititon;

  MedReminder({
    // this.id,
    this.medication,
    this.dosage,
    this.time_reminder,
    // this.repititon,
  });

  MedReminder.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    medication = json['medication'] != null
        ? new Medication.fromJson(json['medication'])
        : null;
    dosage = json['dosage'];
    time_reminder = json['time_reminder'];
    // repititon = json['repititon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    if (this.medication != null) {
      data['medication'] = this.medication!.toJson();
    }
    data['dosage'] = this.dosage;
    data['time_reminder'] = this.time_reminder;
    // data['repititon'] = this.repititon;
    return data;
  }
}
