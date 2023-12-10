import 'dart:convert';

import 'package:allergygenieapi/models/medication/list_medication_response_model.dart';
import 'package:allergygenieapi/services/resource.dart';

class MedicationResource {
  // show list of Medication
  static Resource getListMedication() {
    return Resource(
        url: 'medication',
        parse: (response) {
          return ListMedicationResponseModel(json.decode(response.body));
        });
  }
}
