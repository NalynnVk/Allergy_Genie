import 'package:allergygenieapi/helpers/base_api_response.dart';
import 'package:allergygenieapi/models/tracking/tracking_model.dart';
import 'package:allergygenieapi/models/paginator_model.dart';

class ListTrackingResponseModel extends BaseAPIResponse<List<Tracking>, Null> {
  ListTrackingResponseModel(fullJson) : super(fullJson);

  @override
  dataToJson(List<Tracking>? data) {
    if (this.data != null) {
      return this.data?.map((v) => v.toJson()).toList();
    }
    return null;
  }

  @override
  errorsToJson(Null errors) {
    return null;
  }

  @override
  List<Tracking>? jsonToData(Map<String, dynamic>? json) {
    if (json != null) {
      data = [];

      json["data"].forEach((v) {
        data!.add(Tracking.fromJson(v));
      });

      return data!;
    }

    return null;
  }

  @override
  Null jsonToError(Map<String, dynamic> json) {
    return null;
  }

  @override
  PaginatorModel? jsonToPaginator(Map<String, dynamic> json) {
    // Convert json["paginator"] data to PaginatorModel
    if (json["paginator"] != null) {
      return PaginatorModel.fromJson(json["paginator"]);
    }
    return null;
  }

  @override
  PaginatorModel? paginatorToJson(PaginatorModel? paginatorModel) {
    return null;
  }
}
