/// Communicate with your feathers js (https://feathersjs.com/) server from flutter app.
///
/// Documentation at: https://dahkenangnon.github.io/flutter_feathersjs.dart/
///
/// Repository at: https://github.com/Dahkenangnon/flutter_feathersjs.dart
///
/// Pub.dev: https://pub.dev/packages/flutter_feathersjs/
///
/// Demo api at: https://flutter-feathersjs.herokuapp.com/
///
/// Demo app's repo at: https://github.com/Dahkenangnon/flutter_feathersjs_demo
///
///
///
/// Happy hacking
library flutter_feathersjs;

import 'package:flutter_feathersjs/src/rest_client.dart';
import 'package:flutter_feathersjs/src/scketio_client.dart';
import 'package:flutter_feathersjs/src/utils.dart';
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
///      //Global auth (Rest and Socketio)
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
    try {
      //Auth with rest to refresh or create accessToken
      var restAuthResponse = await rest.authenticate(
          strategy: strategy,
          userName: userName,
          userNameFieldName: userNameFieldName,
          password: password);

      try {
        //Then auth with jwt socketio
        bool isAuthenticated = await scketio.authWithJWT();

        // Check wether both client are authenticated or not
        if (restAuthResponse != null && isAuthenticated == true) {
          return restAuthResponse;
        } else {
          // Both failed
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_AUTH_FAILED_ERROR,
              error: "Auth failed with unknown reason");
        }
      } on FeatherJsError catch (e) {
        // Socketio failed
        throw new FeatherJsError(type: e.type, error: e);
      }
    } on FeatherJsError catch (e) {
      // Rest failed
      throw new FeatherJsError(type: e.type, error: e);
    }
  }

  /// ReAuthenticate rest and scketio clients
  ///
  ///___________________________________________________________________
  Future<dynamic> reAuthenticate() async {
    try {
      //Auth with rest to refresh or create accessToken
      bool isRestAuthenticated = await rest.reAuthenticate();

      try {
        //Then auth with jwt socketio
        bool isSocketioAuthenticated = await scketio.authWithJWT();

        // Check wether both client are authenticated or not
        if (isRestAuthenticated == true && isSocketioAuthenticated == true) {
          return true;
        } else {
          // Both failed
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_AUTH_FAILED_ERROR,
              error: "Auth failed with unknown reason");
        }
      } on FeatherJsError catch (e) {
        // Socketio failed
        throw new FeatherJsError(type: e.type, error: e);
      }
    } on FeatherJsError catch (e) {
      // Rest failed
      throw new FeatherJsError(type: e.type, error: e);
    }
  }
}
