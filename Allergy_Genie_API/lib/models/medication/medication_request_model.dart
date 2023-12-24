class MedicationRequestModel {
  String? name;

  MedicationRequestModel({
    this.name,
  });

  factory MedicationRequestModel.fromJson(Map<String, dynamic> json) {
    return MedicationRequestModel(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
