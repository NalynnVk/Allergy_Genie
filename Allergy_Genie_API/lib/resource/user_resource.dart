import 'dart:convert';

import 'package:allergygenieapi/models/user/login_request_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/models/user/user_request_model.dart';
import 'package:allergygenieapi/models/user/user_response_model.dart';
import 'package:allergygenieapi/models/user/user_update_request_model.dart';
import 'package:allergygenieapi/services/resource.dart';
import 'package:get_it/get_it.dart';

class UserResource {
  // Call Login API
  static Resource login(LoginRequestModel loginRequestModel) {
    return Resource(
        url: 'login',
        data: loginRequestModel.toJson(),
        parse: (response) {
          return UserResponseModel(json.decode(response.body));
        });
  }

// Save user model to GetIt to retrieve the model faster and easier when needed
  static setGetIt(User user) {
    if (!GetIt.instance.isRegistered<User>()) {
      GetIt.instance.registerSingleton<User>(user);
    } else {
      GetIt.instance.unregister<User>();
      GetIt.instance.registerSingleton<User>(user);
    }
  }

  static Resource register(UserRequestModel userRequestModel) {
    return Resource(
        url: 'register',
        data: userRequestModel.toJson(),
        parse: (response) {
          return UserResponseModel(json.decode(response.body));
        });
  }

   static Resource update(UpdateUserRequestModel requestModel, int userId) {
    return Resource(
        url: 'user/$userId',
        data: requestModel,
        parse: (response) {
          return UserResponseModel(json.decode(response.body));
        });
  }
}
