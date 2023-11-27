class Symptom {
  // int? id;
  String? name;
  String? severity;
  String? description;

  Symptom({
    // this.id,
    this.name,
    this.severity,
    this.description,
  });

  Symptom.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    name = json['name'];
    severity = json['severity'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['severity'] = this.severity;
    data['description'] = this.description;
    return data;
  }
}
