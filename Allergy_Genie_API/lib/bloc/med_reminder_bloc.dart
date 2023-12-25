// import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/med_reminder/list_med_reminder_response_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_request_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_response_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_update_request_model.dart';
import 'package:allergygenieapi/resource/med_reminder_resource.dart';
import 'package:allergygenieapi/services/web_services.dart';

class MedReminderBloc {
  
  Future<MedReminderResponseModel> createMedReminder(
       MedReminderRequestModel requestModel) async {
    return await Webservice.post(MedReminderResource.createMedReminder(requestModel));
  }

  // list medReminder
  Future<ListMedReminderResponseModel> getListMedReminder() async {
    return await Webservice.get(MedReminderResource.getListMedReminder());
  }

  // update medReminder
  Future<MedReminderResponseModel> updateMedReminder(UpdateMedReminderRequestModel requestModel,int medReminderId) async {
    return await Webservice.put(
        MedReminderResource.updatemedreminder(requestModel, medReminderId));
  }

  Future<MedReminderResponseModel> delete(int medReminderId) async {
    return await Webservice.delete(
        MedReminderResource.delete(medReminderId));
  }
}
