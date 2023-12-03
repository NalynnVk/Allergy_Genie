import 'dart:convert';

import 'package:allergygenieapi/models/insight/list_insight_response_model.dart';
import 'package:allergygenieapi/services/resource.dart';

class InsightResource {
  // add insight kena? postman ada list, show, add, edit
  // perlu request model?

  // // add insight
  // static Resource createinsight(InsightRequestModel insightRequestModel) {
  //   return Resource(
  //       url: 'insight',
  //       data: insightRequestModel.toJson(),
  //       parse: (response) {
  //         return InsightResponseModel(json.decode(response.body));
  //       });
  // }

  // show list of insight
  static Resource getListInsight() {
    return Resource(
        url: 'insight',
        parse: (response) {
          return ListInsightResponseModel(json.decode(response.body));
        });
  }

  // update insight
  static Resource updateinsight(int insightId) {
    return Resource(
        url: 'insight/$insightId/update',
        parse: (response) {
          return ListInsightResponseModel(json.decode(response.body));
        });
  }
}
