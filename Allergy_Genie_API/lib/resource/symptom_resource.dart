import 'dart:convert';

import 'package:allergygenieapi/models/symptom/list_symptom_response_model.dart';
import 'package:allergygenieapi/services/resource.dart';

class SymptomResource {
  static Resource getListSymptom() {
    return Resource(
        url: 'symptom',
        parse: (response) {
          return ListSymptomResponseModel(json.decode(response.body));
        });
  }
}
