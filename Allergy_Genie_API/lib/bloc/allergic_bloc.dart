import 'package:allergygenieapi/models/allergen/allergen_response_model.dart';
import 'package:allergygenieapi/models/patient/allergic_request_model.dart';
import 'package:allergygenieapi/models/patient/allergic_response_model.dart';
import 'package:allergygenieapi/models/patient/list_allergic_response_model.dart';
import 'package:allergygenieapi/resource/allergic_resource.dart';
import 'package:allergygenieapi/resource/tracking_resource.dart';
import 'package:allergygenieapi/services/web_services.dart';

class AllergicBloc {
  
  // list tracking
  Future<ListAllergicResponseModel> getListAllergic() async {
    return await Webservice.get(AllergicResource.getListAllergic());
  }

  Future<AllergicResponseModel> createAllergic(
      AllergicRequestModel requestModel) async {
    return await Webservice.post(AllergicResource.createAllergic(requestModel));
  }
}
