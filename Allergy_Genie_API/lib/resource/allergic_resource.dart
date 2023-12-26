import 'dart:convert';

import 'package:allergygenieapi/models/patient/allergic_request_model.dart';
import 'package:allergygenieapi/models/patient/allergic_response_model.dart';
import 'package:allergygenieapi/models/patient/list_allergic_response_model.dart';
import 'package:allergygenieapi/services/resource.dart';

class AllergicResource {

  static Resource getListAllergic() {
    return Resource(
        url: 'patient',
        parse: (response) {
          return ListAllergicResponseModel(json.decode(response.body));
        });
  }

  static Resource createAllergic(AllergicRequestModel requestModel) {
    return Resource(
        url: 'patient/myAllergic',
        data: requestModel.toJson(),
        parse: (response) {
          return AllergicResponseModel(json.decode(response.body));
        });
  }
}
