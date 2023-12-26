import 'dart:convert';

import 'package:allergygenieapi/models/careplan/careplan_response_model.dart';
import 'package:allergygenieapi/models/default_response_model.dart';
import 'package:allergygenieapi/models/user/login_request_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/models/user/user_request_model.dart';
import 'package:allergygenieapi/models/user/user_response_model.dart';
import 'package:allergygenieapi/models/user/user_update_request_model.dart';
import 'package:allergygenieapi/services/resource.dart';
import 'package:get_it/get_it.dart';

class CareplanResource {

  static Resource careplan() {
    return Resource(
        url: 'generate-pdf',
        parse: (response) {
          return CareplanResponseModel(json.decode(response.body));
        });
  }
  
}
