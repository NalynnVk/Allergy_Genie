import 'package:flutter/material.dart';

class UpdateMedReminderRequestModel {
  int? patient_id;
  int? medication_id;
  int? dosage;
  int? repititon;
  TimeOfDay? time_reminder;

  UpdateMedReminderRequestModel({
    this.patient_id,
    this.medication_id,
    this.dosage,
    this.repititon,
    this.time_reminder,
  });

  factory UpdateMedReminderRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateMedReminderRequestModel(
      patient_id: json['patient_id'],
      medication_id: json['medication_id'],
      dosage: json['dosage'],
      repititon: json['repititon'],
      time_reminder:
          TimeOfDay.fromDateTime(DateTime.parse(json['time_reminder'])),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patient_id;
    data['medication_id'] = this.medication_id;
    data['repititon'] = this.repititon;
    data['dosage'] = this.dosage;
    if (this.time_reminder != null) {
      data['time_reminder'] =
          "${this.time_reminder!.hour}:${this.time_reminder!.minute}";
    }
    return data;
  }
}
