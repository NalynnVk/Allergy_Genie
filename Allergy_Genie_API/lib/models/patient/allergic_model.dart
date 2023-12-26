import 'package:allergygenieapi/models/allergen/allergen_model.dart';

class Allergic {
  Allergen? allergen;
  int? severityId;
  String? severity;

  Allergic({
    this.allergen,
    this.severityId,
    this.severity,
  });

  //based on exam_schedule_model.dart - dian
  Allergic.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    severityId = json['severityId'];
    severity = json['severity'];
    allergen = json['allergen'] != null
        ? new Allergen.fromJson(json['allergen'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['severityId'] = this.severityId;
    data['severity'] = this.severity;
    if (this.allergen != null) {
      data['allergen'] = this.allergen!.toJson();
    }

    return data;
  }
}
