import 'package:flutter_feathersjs/src/rest_client.dart';
import 'package:flutter_feathersjs/src/scketio_client.dart';
import 'dart:async';
import 'package:flutter_feathersjs/src/helper.dart';
import 'package:meta/meta.dart';

///FlutterFeatherJs allow you to communicate with your feathers js server
///
///Response format: You get exactly what feathers server send when no error
///
///Uploading file: Use rest client, socketio client cannot upload file
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
