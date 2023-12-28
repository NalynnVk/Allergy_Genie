// import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/tracking/tracking_request_model.dart';
import 'package:allergygenieapi/models/tracking/list_tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_update_request_model.dart';
import 'package:allergygenieapi/resource/tracking_resource.dart';
import 'package:allergygenieapi/services/web_services.dart';

class TrackingBloc {
  // // add tracking?
  Future<TrackingResponseModel> createTracking(
      TrackingRequestModel requestModel) async {
    return await Webservice.post(TrackingResource.createTracking(requestModel));
  }

  // Future<TrackingResponseModel> createTracking(
  //     TrackingRequestModel newTracking) async {
  //   return await Webservice.post(TrackingResource.createTracking(),
  //       body: newTracking.toJson());
  // }

  // Future<TrackingResponseModel> createTracking(
  //     TrackingRequestModel requestModel, int trackingId) async {
  //   return await Webservice.post(
  //       TrackingResource.createTracking(trackingId, requestModel));
  // }

  // list tracking
  Future<ListTrackingResponseModel> getListTracking() async {
    return await Webservice.get(TrackingResource.getListTracking());
  }

  // update tracking
  Future<TrackingResponseModel> updateTracking(
      UpdateTrackingRequestModel requestModel, int trackingId) async {
    return await Webservice.put(
        TrackingResource.updatetracking(requestModel, trackingId));
  }

  //Storetracking
  //   Future<TrackingResponseModel> storeTracking(TrackingRequestModel requestModel) async {
  //   return await Webservice.put(TrackingResource.storeTracking(requestModel));
  // }
}
