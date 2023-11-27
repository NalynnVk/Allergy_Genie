import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/helpers/secure_storage_api.dart';
import 'package:allergygenieapi/models/user/login_request_model.dart';
import 'package:allergygenieapi/models/user/user_response_model.dart';
import 'package:allergygenieapi/resource/user_resource.dart';
import 'package:allergygenieapi/services/web_services.dart';

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
}
