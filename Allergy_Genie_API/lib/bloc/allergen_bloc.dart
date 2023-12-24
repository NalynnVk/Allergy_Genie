import 'package:allergygenieapi/models/allergen/allergen_request_model.dart';
import 'package:allergygenieapi/models/allergen/allergen_response_model.dart';
import 'package:allergygenieapi/models/allergen/list_allergen_response_model.dart';
import 'package:allergygenieapi/resource/allergen_resource.dart';
import 'package:allergygenieapi/services/web_services.dart';

class AllergenBloc {
  // list Allergen
  Future<ListAllergenResponseModel> getListAllergen() async {
    return await Webservice.get(AllergenResource.getListAllergen());
  }

  // add Allergen
  Future<AllergenResponseModel> createAllergen(
      AllergenRequestModel requestModel) async {
    return await Webservice.post(AllergenResource.createAllergen(requestModel));
  }
}
