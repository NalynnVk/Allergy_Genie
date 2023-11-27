import 'package:allergygenieapi/helpers/base_api_response.dart';
import 'package:allergygenieapi/models/paginator_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';

class UserResponseModel extends BaseAPIResponse<User, Null> {
  UserResponseModel(fullJson) : super(fullJson);

  @override
  dataToJson(User? data) {
    if (this.data != null) {
      return this.data!.toJson();
    }
    return null;
  }

  @override
  errorsToJson(Null errors) {
    return null;
  }

  @override
  User? jsonToData(Map<String, dynamic>? json) {
    return json!["data"] != null ? User.fromJson(json["data"]) : null;
  }

  @override
  Null jsonToError(Map<String, dynamic> json) {
    return null;
  }

  @override
  PaginatorModel? jsonToPaginator(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  PaginatorModel? paginatorToJson(PaginatorModel? paginatorModel) {
    throw UnimplementedError();
  }
}
