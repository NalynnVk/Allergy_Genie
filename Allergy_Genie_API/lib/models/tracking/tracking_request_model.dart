class TrackingRequestModel {
  // String? patient_id;
  int? symptom_id;
  int? allergen_id;

  TrackingRequestModel({this.allergen_id, this.symptom_id});

  factory TrackingRequestModel.fromJson(Map<String, dynamic> json) {
    return TrackingRequestModel(
      // patient_id: json['patient_id'],
      symptom_id: json['symptom_id'],
      allergen_id: json['allergen_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['patient_id'] = this.patient_id;
    data['symptom_id'] = this.symptom_id;
    data['allergen_id'] = this.allergen_id;
    return data;
  }
}
