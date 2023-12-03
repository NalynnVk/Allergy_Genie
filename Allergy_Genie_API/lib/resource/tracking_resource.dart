import 'dart:convert';

import 'package:allergygenieapi/models/tracking/tracking_request_model.dart';
import 'package:allergygenieapi/models/tracking/list_tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_response_model.dart';
import 'package:allergygenieapi/services/resource.dart';

class TrackingResource {
  // add tracking kena? postman ada list, show, add, edit
  // perlu request model?

  // add tracking
  static Resource createtracking(TrackingRequestModel trackingRequestModel) {
    return Resource(
        url: 'tracking',
        data: trackingRequestModel.toJson(),
        parse: (response) {
          return TrackingResponseModel(json.decode(response.body));
        });
  }

  // show list of tracking
  static Resource getListTracking() {
    return Resource(
        url: 'tracking',
        parse: (response) {
          return ListTrackingResponseModel(json.decode(response.body));
        });
  }

  // update tracking
  static Resource updatetracking(int trackingId) {
    return Resource(
        url: 'tracking/$trackingId/update',
        parse: (response) {
          return TrackingResponseModel(json.decode(response.body));
        });
  }
}
