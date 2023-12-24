import 'package:allergygenieapi/helpers/base_api_response.dart';
import 'package:allergygenieapi/models/allergen/allergen_model.dart';
import 'package:allergygenieapi/models/paginator_model.dart';

class AllergenResponseModel extends BaseAPIResponse<Allergen, Null> {
  AllergenResponseModel(fullJson) : super(fullJson);

  @override
  dataToJson(Allergen? data) {
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
  Allergen? jsonToData(Map<String, dynamic>? json) {
    return json!["data"] != null ? Allergen.fromJson(json["data"]) : null;
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
