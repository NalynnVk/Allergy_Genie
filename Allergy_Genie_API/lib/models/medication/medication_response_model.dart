import 'package:allergygenieapi/helpers/base_api_response.dart';
import 'package:allergygenieapi/models/medication/medication_model.dart';
import 'package:allergygenieapi/models/paginator_model.dart';

class MedicationResponseModel extends BaseAPIResponse<Medication, Null> {
  MedicationResponseModel(fullJson) : super(fullJson);

  @override
  dataToJson(Medication? data) {
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
  Medication? jsonToData(Map<String, dynamic>? json) {
    return json!["data"] != null ? Medication.fromJson(json["data"]) : null;
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
