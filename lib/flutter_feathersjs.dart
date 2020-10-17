library flutter_feathersjs;

import 'package:flutter_feathersjs/src/constants.dart';
import 'package:flutter_feathersjs/src/rest_client.dart';
import 'package:flutter_feathersjs/src/scketio_client.dart';
import 'package:meta/meta.dart';

/// FlutterFeatherJs allow you to communicate with your feathers js server
class FlutterFeathersjs {
  //RestClient
  RestClient rest;
  //SocketioClient
  SocketioClient scketio;
  Constants isCode;

  ///Using singleton
  static final FlutterFeathersjs _flutterFeathersjs =
      FlutterFeathersjs._internal();
  factory FlutterFeathersjs() {
    return _flutterFeathersjs;
  }
  FlutterFeathersjs._internal();

  ///Intialize both rest and scoketio client
  init({@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    rest = new RestClient()..init(baseUrl: baseUrl, extraHeaders: extraHeaders);
    scketio = new SocketioClient()..init(baseUrl: baseUrl);
  }

  /// Authenticate rest and scketio clients so you can use both of them
  Future<Map<String, dynamic>> authenticate(
      {@required String email, @required String password}) async {
    //Hold global auth infos
    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": "UNKNOWN",
      "message": "An error occured either on rest or socketio auth",
      "restResponse": {},
      "scketResponse": {}
    };

    //Auth with rest to refresh or create accessToken
    Map<String, dynamic> restAuthResponse =
        await rest.authenticate(email: email, password: password);
    //Then auth with jwt socketio
    Map<String, dynamic> socketioAuthResponse = await scketio.authWithJWT();

    //Finally send response
    if (!restAuthResponse["error"] && !socketioAuthResponse["error"]) {
      authResponse = restAuthResponse;
    } else {
      authResponse["restResponse"] = restAuthResponse;
      authResponse["scketResponse"] = socketioAuthResponse;
    }
    return authResponse;
  }

  /// Authenticate rest and scketio clients so you can use both of them
  Future<Map<String, dynamic>> reAuthenticate() async {
    //Hold global auth infos
    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": isCode.UNKNOWN_ERROR,
      "message": "An error occured either on rest or socketio auth",
      "restResponse": {},
      "scketResponse": {}
    };

    //Auth with rest to refresh or create accessToken
    Map<String, dynamic> restAuthResponse = await rest.reAuthenticate();
    //Then auth with jwt socketio
    Map<String, dynamic> socketioAuthResponse = await scketio.authWithJWT();

    //Finally send response
    if (!restAuthResponse["error"] && !socketioAuthResponse["error"]) {
      authResponse["error"] = false;
      authResponse["error_zone"] = isCode.BOTH_CLIENT_AUTHED;
      authResponse["message"] = socketioAuthResponse;
    } else {
      authResponse["error"] = true;
      authResponse["error_zone"] = isCode.ONE_OR_BOTH_CLIENT_NOT_AUTHED;
      authResponse["message"] =
          "One or both client is(are) not authed. Please checkout restResponse field or scketResponse field for more infos.";
      authResponse["restResponse"] = restAuthResponse;
      authResponse["scketResponse"] = socketioAuthResponse;
    }
    return authResponse;
  }
}
