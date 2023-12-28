import 'dart:convert';

import 'package:allergygenieapi/models/tracking/tracking_request_model.dart';
import 'package:allergygenieapi/models/tracking/list_tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_update_request_model.dart';
import 'package:allergygenieapi/services/resource.dart';

class TrackingResource {
  static Resource createTracking(TrackingRequestModel requestModel) {
    return Resource(
        url: 'tracking',
        data: requestModel.toJson(),
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
  static Resource updatetracking(
      UpdateTrackingRequestModel requestModel, int trackingId) {
    return Resource(
        url: 'tracking/$trackingId',
        data: requestModel,
        parse: (response) {
          return TrackingResponseModel(json.decode(response.body));
        });
  }

  //store tracking
  // static Resource storeTracking(TrackingRequestModel requestModel) {
  //   return Resource(
  //       url: 'tracking/',
  //       parse: (response) {
  //         return TrackingResponseModel(json.decode(response.body));
  //       });
  // }
}
