// import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/medication/list_medication_response_model.dart';
// import 'package:allergygenieapi/models/medication/medication_response_model.dart';
import 'package:allergygenieapi/resource/medication_resource.dart';
import 'package:allergygenieapi/services/web_services.dart';

class MedicationBloc {

  // list Medication
  Future<ListMedicationResponseModel> getListMedication() async {
    return await Webservice.get(MedicationResource.getListMedication());
  }

  // // update Medication
  // Future<MedicationResponseModel> updateMedication(int medicationId) async {
  //   return await Webservice.put(
  //       MedicationResource.updatemedication(medicationId));
  // }
}
