import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/tracking/tracking_request_model.dart';
import 'package:allergygenieapi/models/tracking/list_tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_response_model.dart';
import 'package:allergygenieapi/resource/tracking_resource.dart';
import 'package:allergygenieapi/services/web_services.dart';

class TrackingBloc {
  // add tracking?
  // Future<TrackingResponseModel> createTracking(TrackingRequestModel newTracking) async {
  //   return await Webservice.post(TrackingResource.createTracking(), body: newTracking.toJson());
  // }

  // list tracking
  Future<ListTrackingResponseModel> getListTracking() async {
    return await Webservice.get(TrackingResource.getListTracking());
  }

  // update tracking
  Future<TrackingResponseModel> updateTracking(int trackingId) async {
    return await Webservice.put(TrackingResource.updateracking(trackingId));
  }
}
