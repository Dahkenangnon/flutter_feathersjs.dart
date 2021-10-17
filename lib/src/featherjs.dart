import 'package:flutter_feathersjs/src/rest_client.dart';
import 'package:flutter_feathersjs/src/scketio_client.dart';
import 'dart:async';
import 'package:flutter_feathersjs/src/helper.dart';

///FlutterFeatherJs allow you to communicate with your feathers js server
///
///Response format: You get exactly what feathers server send when no error occured
///
///Uploading file: Use rest client, socketio client cannot upload file
///
///--------------------------------------------
/// Because we love the realtime side of
/// feathers js, by default socketio's methods
/// can be used on FlutterFeathersjs.{methodName}
///--------------------------------------------
class FlutterFeathersjs {
  //RestClient
  late RestClient rest;


  //SocketioClient
  late SocketioClient scketio;

  ///Using singleton
  static final FlutterFeathersjs _flutterFeathersjs =
      FlutterFeathersjs._internal();


  factory FlutterFeathersjs() {
    return _flutterFeathersjs;
  }
  FlutterFeathersjs._internal();

  ///Initialize both rest and scoketio client
  init({required String baseUrl, Map<String, dynamic>? extraHeaders}) {
    rest = new RestClient()..init(baseUrl: baseUrl, extraHeaders: extraHeaders);

    scketio = new SocketioClient()..init(baseUrl: baseUrl);
  }

  /// Authenticate rest and scketio clients so you can use both of them
  ///
  ///___________________________________________________________________
  /// @params `username` can be : email, phone, etc;
  ///
  /// But ensure that `userNameFieldName` is correct with your chosed `strategy` on your feathers js server
  ///
  /// By default this will be `email`and the strategy `local`
  Future<Map<String, dynamic>> authenticate(
      {String strategy = "local",
      required String? userName,
      required String? password,
      String userNameFieldName = "email"}) async {
    try {
      //Auth with rest to refresh or create new accessToken
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

  ///--------------------------------------------
  /// Because we love the realtime side of
  /// feathers js, by default socketio's methods
  /// are used on FlutterFeathersjs.{methodName}
  ///--------------------------------------------

  /// `EMIT find serviceName`
  ///
  /// Retrieves a list of all matching `query` resources from the service
  ///
  /// If no error is occured, you will get exactly feathersjs's data format
  ///
  /// Otherwise, an exception of type FeatherJsError will be raised
  ///
  /// Use FeatherJsErrorType.{ERROR} to known what happen
  ///
  ///
  Future<dynamic> find(
      {required String serviceName,
      required Map<String, dynamic> query}) async {
    return this.scketio.find(serviceName: serviceName, query: query);
  }

  /// `EMIT create serviceName`
  ///
  /// Create new ressource
  ///
  /// If no error is occured, you will get exactly feathersjs's data format
  ///
  /// Otherwise, an exception of type FeatherJsError will be raised
  ///
  /// Use FeatherJsErrorType.{ERROR} to known what happen
  ///
  /// @Warning: If uploading file is required, please use FlutterFeathersjs's rest client
  ///
  Future<dynamic> create(
      {required String serviceName, required Map<String, dynamic> data}) {
    return this.scketio.create(serviceName: serviceName, data: data);
  }

  /// `EMIT update serviceName`
  ///
  /// Update a  ressource
  ///
  ///
  /// If no error is occured, you will get exactly feathersjs's data format
  ///
  /// Otherwise, an exception of type FeatherJsError will be raised
  ///
  /// Use FeatherJsErrorType.{ERROR} to known what happen
  ///
  /// @Warning: If uploading file is required, please use FlutterFeathersjs's rest client
  ///
  Future<dynamic> update(
      {required String serviceName,
      required String objectId,
      required Map<String, dynamic> data}) {
    return this
        .scketio
        .update(serviceName: serviceName, objectId: objectId, data: data);
  }

  /// `EMIT get serviceName`
  ///
  ///
  /// If no error is occured, you will get exactly feathersjs's data format
  ///
  /// Otherwise, an exception of type FeatherJsError will be raised
  ///
  /// Use FeatherJsErrorType.{ERROR} to known what happen
  ///
  Future<dynamic> get({required String serviceName, required String objectId}) {
    return this.scketio.get(serviceName: serviceName, objectId: objectId);
  }

  /// `EMIT patch serviceName`
  ///
  /// Merge the existing data of a single or multiple resources with the new data
  ///
  /// If no error is occured, you will get exactly feathersjs's data format
  ///
  /// Otherwise, an exception of type FeatherJsError will be raised
  ///
  /// Use FeatherJsErrorType.{ERROR} to known what happen
  ///
  /// @Warning: If uploading file is required, please use FlutterFeathersjs's rest client
  ///
  Future<dynamic> patch(
      {required String serviceName,
      required String objectId,
      required Map<String, dynamic> data}) {
    return this
        .scketio
        .patch(serviceName: serviceName, objectId: objectId, data: data);
  }

  /// `EMIT remove serviceName`
  ///
  /// Delete a ressource on the server
  ///
  ///
  /// If no error is occured, you will get exactly feathersjs's data format
  ///
  /// Otherwise, an exception of type FeatherJsError will be raised
  ///
  /// Use FeatherJsErrorType.{ERROR} to known what happen
  ///
  Future<dynamic> remove(
      {required String serviceName, required String objectId}) {
    return this.scketio.remove(serviceName: serviceName, objectId: objectId);
  }

  /// Listen to On [` updated | patched | created | removed `] `serviceName`
  ///
  /// If no error is occured, you will get FeathersJsEventData<T>  feathersJsEventData
  ///
  ///     Then to retrieve the data send by feathers, do: feathersJsEventData.data
  ///
  ///     Event type send by feathers: feathersJsEventData.type
  ///
  /// Note: T is class that represent what feather js will send. You have to define it in your code
  ///
  ///
  /// Otherwise, an exception of type FeatherJsError will be raised that can be caught on the stream
  ///
  ///     Use FeatherJsErrorType.{ERROR} to known what happen
  ///
  Stream<FeathersJsEventData<T>> listen<T>(
      {required String serviceName, required Function fromJson}) {
    return this.scketio.listen(serviceName: serviceName, fromJson: fromJson);
  }
}
