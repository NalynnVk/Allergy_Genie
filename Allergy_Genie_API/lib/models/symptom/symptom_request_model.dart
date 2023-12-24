import 'package:flutter/material.dart';

class SymptomRequestModel {
  String? name;
  int? severity;
  Text? description;

  SymptomRequestModel({this.name, this.severity, this.description});

  factory SymptomRequestModel.fromJson(Map<String, dynamic> json) {
    return SymptomRequestModel(
      name: json['name'],
      severity: json['severity'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['severity'] = this.severity;
    data['description'] = this.description;
    return data;
  }
}
