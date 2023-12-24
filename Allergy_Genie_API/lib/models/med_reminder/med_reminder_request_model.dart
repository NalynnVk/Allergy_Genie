import 'package:flutter/material.dart';

class MedReminderRequestModel {
  // String? patient_id;
  int? medication_id;
  String? dosage;
  TimeOfDay? time_reminder;

  MedReminderRequestModel({
    this.medication_id,
    this.dosage,
    this.time_reminder,
  });

  factory MedReminderRequestModel.fromJson(Map<String, dynamic> json) {
    return MedReminderRequestModel(
      medication_id: json['medication_id'],
      dosage: json['dosage'],
      time_reminder:
          TimeOfDay.fromDateTime(DateTime.parse(json['time_reminder'])),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['patient_id'] = this.patient_id;
    data['medication_id'] = this.medication_id;
    data['dosage'] = this.dosage;
    if (this.time_reminder != null) {
      data['time_reminder'] =
          "${this.time_reminder!.hour}:${this.time_reminder!.minute}";
    }
    return data;
  }
}
