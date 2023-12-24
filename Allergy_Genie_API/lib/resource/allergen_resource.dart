import 'dart:convert';

import 'package:allergygenieapi/models/allergen/allergen_request_model.dart';
import 'package:allergygenieapi/models/allergen/allergen_response_model.dart';
import 'package:allergygenieapi/models/allergen/list_allergen_response_model.dart';
import 'package:allergygenieapi/services/resource.dart';

class AllergenResource {
  // show list of Allergen
  static Resource getListAllergen() {
    return Resource(
        url: 'allergen',
        parse: (response) {
          return ListAllergenResponseModel(json.decode(response.body));
        });
  }

  // add allergen
  static Resource createAllergen(AllergenRequestModel requestModel) {
    return Resource(
        url: 'allergen',
        data: requestModel.toJson(),
        parse: (response) {
          return AllergenResponseModel(json.decode(response.body));
        });
  }
}
