class MedReminderRequestModel {
  // String? patient_id;
  String? medication_id;
  // String? dosage;
  // String? time_reminder;
  // String? repititon;

  MedReminderRequestModel({
    this.medication_id,
    // this.dosage,
    // this.time_reminder,
    // this.repititon,
  });

  factory MedReminderRequestModel.fromJson(Map<String, dynamic> json) {
    return MedReminderRequestModel(
      medication_id: json['medication_id'],
      // dosage: json['dosage'],
      // time_reminder: json['time_reminder'],
      // repititon: json['repititon'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['patient_id'] = this.patient_id;
    data['medication_id'] = this.medication_id;
    // data['dosage'] = this.dosage;
    // data['time_reminder'] = this.time_reminder;
    // data['repititon'] = this.repititon;
    return data;
  }
}
