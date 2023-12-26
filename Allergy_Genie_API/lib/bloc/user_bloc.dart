import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/helpers/secure_storage_api.dart';
import 'package:allergygenieapi/models/default_response_model.dart';
import 'package:allergygenieapi/models/user/login_request_model.dart';
import 'package:allergygenieapi/models/user/user_request_model.dart';
import 'package:allergygenieapi/models/user/user_response_model.dart';
import 'package:allergygenieapi/models/user/user_update_request_model.dart';
import 'package:allergygenieapi/public_components/theme_snack_bar.dart';
import 'package:allergygenieapi/resource/user_resource.dart';
import 'package:allergygenieapi/screens/basic/login_screen.dart';
import 'package:allergygenieapi/services/web_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UserBloc {
  // Login
  Future<UserResponseModel> login(LoginRequestModel loginModel) async {
    // Call the API to login
    final UserResponseModel response =
        await Webservice.post(UserResource.login(loginModel));
    if (response.statusCode == HttpResponse.HTTP_OK) {
      if (response.data != null && response.data!.access_token != null) {
        //save in secured storage
        await SecureStorageApi.write(
            key: "access_token", value: response.data!.access_token!);
        //save in secured storage
        await SecureStorageApi.saveObject("user", response.data);
        //save in GetIt
        UserResource.setGetIt(response.data!);
      }
    }
    return response;
  }

  Future<UserResponseModel> register(UserRequestModel userRequestModel) async {
    return await Webservice.post(UserResource.register(userRequestModel));
  }

  Future<UserResponseModel> update(UpdateUserRequestModel requestModel ,int userId) async {
    return await Webservice.put(UserResource.update(requestModel, userId));
  }

  Future<DefaultResponseModel> signOut(context) async {
    // Revoked User Token
    DefaultResponseModel defaultResponseModel =
        await Webservice.get(UserResource.logout());

    // If success or already unauthorized clear data in storage
    if (defaultResponseModel.isSuccess ||
        defaultResponseModel.statusCode == HttpResponse.HTTP_UNAUTHORIZED) {
      await GetIt.instance.reset();
      await SecureStorageApi.delete(key: "access_token");

      // Navigate to Sign In Screen
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);

      ThemeSnackBar.showSnackBar(context, "You're logged out.");
    }

    return defaultResponseModel;
  }
}
