class UpdateTrackingRequestModel {
  int? patient_id;
  int? symptom_id;
  int? allergen_id;
  int? severity;
  String? notes;

  UpdateTrackingRequestModel(
      {this.allergen_id,
      this.symptom_id,
      this.severity,
      this.notes,
      this.patient_id});

  UpdateTrackingRequestModel.fromJson(Map<String, dynamic> json) {
    patient_id = json['patient_id'];
    symptom_id = json['symptom_id'];
    allergen_id = json['allergen_id'];
    severity = json['severity'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patient_id;
    data['symptom_id'] = this.symptom_id;
    data['allergen_id'] = this.allergen_id;
    data['severity'] = this.severity;
    data['notes'] = this.notes;
    return data;
  }
}
