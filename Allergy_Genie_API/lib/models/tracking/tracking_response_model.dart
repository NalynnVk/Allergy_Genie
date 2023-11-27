import 'package:allergygenieapi/helpers/base_api_response.dart';
import 'package:allergygenieapi/models/paginator_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_model.dart';

class TrackingResponseModel extends BaseAPIResponse<Tracking, Null> {
  TrackingResponseModel(fullJson) : super(fullJson);

  @override
  dataToJson(Tracking? data) {
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
  Tracking? jsonToData(Map<String, dynamic>? json) {
    return json!["data"] != null ? Tracking.fromJson(json["data"]) : null;
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
