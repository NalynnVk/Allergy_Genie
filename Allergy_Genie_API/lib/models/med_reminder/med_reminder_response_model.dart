import 'package:allergygenieapi/helpers/base_api_response.dart';
import 'package:allergygenieapi/models/paginator_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_model.dart';

class MedReminderResponseModel extends BaseAPIResponse<MedReminder, Null> {
  MedReminderResponseModel(fullJson) : super(fullJson);

  @override
  dataToJson(MedReminder? data) {
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
  MedReminder? jsonToData(Map<String, dynamic>? json) {
    return json!["data"] != null ? MedReminder.fromJson(json["data"]) : null;
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
