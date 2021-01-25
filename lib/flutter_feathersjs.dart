/// Communicate with your feathers js (https://feathersjs.com/) server from flutter app.
library flutter_feathersjs;

import 'package:flutter_feathersjs/src/constants.dart';
import 'package:flutter_feathersjs/src/rest_client.dart';
import 'package:flutter_feathersjs/src/scketio_client.dart';
import 'package:meta/meta.dart';
//import 'package:flutter/foundation.dart' as Foundation;

///
///FlutterFeatherJs allow you to communicate with your feathers js server
///
///_______________________________________________
///_______________________________________________
///
///
/// `GENERAL NOTE 1`: Serialization and Deserialization are not supported.
///
/// You get exactly what feathers server send
///
/// `GENERAL NOTE 2`: To send file, use rest client, socketio client cannot upload file
///
/// Authentification is processed by:
///
///     // Global auth (Rest and Socketio)
///     var rep = await flutterFeathersjs
///     .authenticate(userName: user["email"], password: user["password"]);
///
///     //Then use this one to reUse access token as it still valided
///      var reAuthResp = await flutterFeathersjs.reAuthenticate();
///
///
class FlutterFeathersjs {
  //RestClient
  RestClient rest;
  //SocketioClient
  SocketioClient scketio;

  // For debug purpose
  bool dev = false;

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
  ///
  ///___________________________________________________________________
  /// @params `username` can be : email, phone, etc;
  ///
  /// But ensure that `userNameFieldName` is correct with your chosed `strategy`
  ///
  /// By default this will be `email`and the strategy `local`
  Future<Map<String, dynamic>> authenticate(
      {String strategy = "local",
      @required String userName,
      @required String password,
      String userNameFieldName = "email"}) async {
    //Hold global auth infos
    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": "UNKNOWN",
      "message": "An error occured either on rest or socketio auth",
      "restResponse": {},
      "scketResponse": {}
    };

    //Auth with rest to refresh or create accessToken
    Map<String, dynamic> restAuthResponse = await rest.authenticate(
        strategy: strategy,
        userName: userName,
        userNameFieldName: userNameFieldName,
        password: password);
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
  ///
  ///___________________________________________________________________
  Future<Map<String, dynamic>> reAuthenticate() async {
    //Hold global auth infos
    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": Constants.UNKNOWN_ERROR,
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
      authResponse["error_zone"] = Constants.BOTH_CLIENT_AUTHED;
      authResponse["message"] = socketioAuthResponse["message"];
    } else {
      authResponse["error"] = true;
      authResponse["error_zone"] = Constants.ONE_OR_BOTH_CLIENT_NOT_AUTHED;
      authResponse["message"] =
          "One or both client is(are) not authed. Please checkout restResponse field or scketResponse field for more infos.";
      authResponse["restResponse"] = restAuthResponse;
      authResponse["scketResponse"] = socketioAuthResponse;
    }
    return authResponse;
  }
}
