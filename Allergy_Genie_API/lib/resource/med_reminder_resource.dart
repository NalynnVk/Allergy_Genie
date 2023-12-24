import 'dart:convert';

import 'package:allergygenieapi/models/med_reminder/list_med_reminder_response_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_request_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_response_model.dart';
import 'package:allergygenieapi/services/resource.dart';

class MedReminderResource {
  // add medreminder kena? postman ada list, show, add, edit
  // perlu request model?

  // add medreminder
  static Resource createMedReminder(MedReminderRequestModel requestModel) {
    return Resource(
        // ikut url POSTMAN
        url: 'medicationreminder',
        data: requestModel.toJson(),
        parse: (response) {
          return MedReminderResponseModel(json.decode(response.body));
        });
  }

  // show list of MedReminder
  static Resource getListMedReminder() {
    return Resource(
        url: 'medicationreminder',
        parse: (response) {
          return ListMedReminderResponseModel(json.decode(response.body));
        });
  }

  // update medreminder
  static Resource updatemedreminder(int medreminderId) {
    return Resource(
        url: 'medicationreminder/$medreminderId/update',
        parse: (response) {
          return MedReminderResponseModel(json.decode(response.body));
        });
  }
}
