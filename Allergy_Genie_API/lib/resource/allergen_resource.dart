import 'dart:convert';

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
}
