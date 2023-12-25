import 'package:allergygenieapi/models/allergen/allergen_model.dart';
import 'package:allergygenieapi/models/symptom/symptom_model.dart';

class Tracking {
  // int? id;
  Symptom? symptom;
  Allergen? allergen;
  int? severityId;
  String? severity;
  String? notes;

  Tracking({
    // this.id,
    this.symptom,
    this.allergen,
    this.severityId,
    this.severity,
    this.notes,
  });

  //based on exam_schedule_model.dart - dian
  Tracking.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    severityId = json['severityId'];
    severity = json['severity'];
    notes = json['notes'];
    symptom =
        json['symptom'] != null ? new Symptom.fromJson(json['symptom']) : null;
    allergen = json['allergen'] != null
        ? new Allergen.fromJson(json['allergen'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['severityId'] = this.severityId;
    data['severity'] = this.severity;
    data['notes'] = this.notes;
    if (this.symptom != null) {
      data['symptom'] = this.symptom!.toJson();
    }
    if (this.allergen != null) {
      data['allergen'] = this.allergen!.toJson();
    }
    data['severity'] = this.severity;
    // data['notes'] = this.notes;
    return data;
  }
}
