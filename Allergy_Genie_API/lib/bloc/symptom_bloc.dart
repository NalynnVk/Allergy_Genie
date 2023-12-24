import 'package:allergygenieapi/models/symptom/list_symptom_response_model.dart';
import 'package:allergygenieapi/resource/symptom_resource.dart';
import 'package:allergygenieapi/services/web_services.dart';

class SymptomBloc {
  Future<ListSymptomResponseModel> getListSymptom() async {
    return await Webservice.get(SymptomResource.getListSymptom());
  }

}
