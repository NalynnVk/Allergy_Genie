class AllergicRequestModel {
  int? patient_id;
  int? allergen_id;
  int? severity;

  AllergicRequestModel({this.allergen_id,  this.severity, this.patient_id });

  AllergicRequestModel.fromJson(Map<String, dynamic> json) {
      patient_id= json['patient_id'];
      allergen_id= json['allergen_id'];
      severity= json['severity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patient_id;
    data['allergen_id'] = this.allergen_id;
    data['severity'] = this.severity;
    return data;
  }
}
