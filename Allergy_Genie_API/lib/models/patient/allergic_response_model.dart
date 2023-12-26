import 'package:allergygenieapi/helpers/base_api_response.dart';
import 'package:allergygenieapi/models/paginator_model.dart';
import 'package:allergygenieapi/models/patient/allergic_model.dart';

class AllergicResponseModel extends BaseAPIResponse<Allergic, Null> {
  AllergicResponseModel(fullJson) : super(fullJson);

  @override
  dataToJson(Allergic? data) {
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
  Allergic? jsonToData(Map<String, dynamic>? json) {
    return json!["data"] != null ? Allergic.fromJson(json["data"]) : null;
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
