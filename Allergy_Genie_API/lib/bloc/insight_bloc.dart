import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/insight/list_insight_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_request_model.dart';
import 'package:allergygenieapi/models/tracking/list_tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_response_model.dart';
import 'package:allergygenieapi/resource/insight_resource.dart';
import 'package:allergygenieapi/resource/tracking_resource.dart';
import 'package:allergygenieapi/services/web_services.dart';

class InsightBloc {
  // add tracking?
  // Future<TrackingResponseModel> createTracking(TrackingRequestModel newTracking) async {
  //   return await Webservice.post(TrackingResource.createTracking(), body: newTracking.toJson());
  // }

  // list tracking
  Future<ListInsightResponseModel> getListInsight() async {
    return await Webservice.get(InsightResource.getListInsight());
  }

  // update Insight
  Future<ListInsightResponseModel> updateInsight(int insightId) async {
    return await Webservice.put(InsightResource.updateinsight(insightId));
  }
}
