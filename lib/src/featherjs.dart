import 'package:dio/dio.dart';
import 'package:flutter_feathersjs/src/config/secure_storage.dart';
import 'package:flutter_feathersjs/src/rest_client.dart';
import 'package:flutter_feathersjs/src/scketio_client.dart';
import 'dart:async';
import 'package:flutter_feathersjs/src/config/helper.dart';
import 'package:flutter_feathersjs/src/standalone_rest_client.dart';
import 'package:flutter_feathersjs/src/standalone_socketio_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'config/constants.dart';

/// [FlutterFeatherJs] allow you to communicate with your feathers js server
///
/// {@template response_format}
/// If no error occured, you will get exactly feathersjs's data format
///
/// Otherwise, an exception of type FeatherJsError will be raised
///
/// Use [FeatherJsErrorType].{ERROR} to known what happen
/// {@endtemplate}
///
/// {@template use_rest_to_upload_file}
/// Uploading file ?: Use rest client, socketio client cannot upload file
/// {@endtemplate}
///
/// {@template love_realtime}
/// --------------------------------------------
/// Because we love the realtime side of
/// feathers js, by default socketio's methods
/// can be used on [FlutterFeathersjs].{methodName}
/// --------------------------------------------
///{@endtemplate}
class FlutterFeathersjs {
  //RestClient
  late RestClient rest;

  // Rest client for standalone usage
  late FlutterFeathersjsRest? standaloneRest;

  //SocketioClient
  late SocketioClient scketio;

  // Socketio client for standalone usage
  late FlutterFeathersjsSocketio? standaloneSocketio;

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

  /// {@macro love_realtime}
  ///
  /// `EMIT find serviceName`
  ///
  /// Retrieves a list of all matching `query` resources from the service
  ///
  /// {@macro response_format}
  ///
  ///
  Future<dynamic> find({
    required String serviceName,
    required Map<String, dynamic> query,
  }) async {
    return this.scketio.find(serviceName: serviceName, query: query);
  }

  /// `EMIT create serviceName`
  ///
  /// Create new ressource
  ///
  /// {@macro response_format}
  ///
  /// {@macro use_rest_to_upload_file}
  ///
  Future<dynamic> create({
    required String serviceName,
    required Map<String, dynamic> data,
    Map<String, dynamic> params = const {}
  }) {
    return this.scketio.create(
        serviceName: serviceName, data: data, params: params
    );
  }

  /// `EMIT update serviceName`
  ///
  /// Update a  ressource
  ///
  ///
  /// {@macro response_format}
  ///
  /// {@macro use_rest_to_upload_file}
  ///
  Future<dynamic> update({
    required String serviceName,
    required String objectId,
    required Map<String, dynamic> data,
    Map<String, dynamic> params = const {}
  }) {
    return this.scketio.update(
        serviceName: serviceName, objectId: objectId, data: data, params: params
    );
  }

  /// `EMIT get serviceName`
  ///
  ///
  /// {@macro response_format}
  ///
  Future<dynamic> get({
    required String serviceName,
    required String objectId,
    Map<String, dynamic> params = const {}
  }) {
    return this.scketio.get(
        serviceName: serviceName, objectId: objectId, params: params
    );
  }

  /// `EMIT patch serviceName`
  ///
  /// Merge the existing data of a single or multiple resources with the new data
  ///
  /// {@macro response_format}
  ///
  /// {@macro use_rest_to_upload_file}
  ///
  Future<dynamic> patch({
    required String serviceName,
    required String objectId,
    required Map<String, dynamic> data,
    Map<String, dynamic> params = const {}
  }) {
    return this.scketio.patch(
        serviceName: serviceName, objectId: objectId, data: data, params: params
    );
  }

  /// `EMIT remove serviceName`
  ///
  /// Delete a ressource on the server
  ///
  ///
  /// {@macro response_format}
  ///
  Future<dynamic> remove({
    required String serviceName,
    required String objectId,
    Map<String, dynamic> params = const {}
  }) {
    return this.scketio.remove(
        serviceName: serviceName, objectId: objectId, params: params
    );
  }

  /// Listen to On [` updated | patched | created | removed `] `serviceName`
  ///
  /// If no error occured, you will get FeathersJsEventData<T>  feathersJsEventData
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

  /// Configure a standalone client for feathers js
  ///
  /// [client] is the http client or socketio that will be used to communicate with feathers js server
  ///
  /// This should be used when you want standalone rest|socketio client
  ///
  void configure(dynamic client) {
    if (client is FlutterFeathersjsSocketio) {
      this.standaloneSocketio = client;
    } else if (client is FlutterFeathersjsRest) {
      this.standaloneRest = client;
    } else {
      throw new FeatherJsError(
          type: FeatherJsErrorType.CONFIGURATION_ERROR,
          error: "Client is not a valid feathers js client. ");
    }
  }

  /// Get the standalone rest client
  ///
  /// This should be used when you want standalone rest client
  ///
  /// You should configure your [dio] client before passing to this method
  ///
  /// Configuring can mean adding interceptors, headers, baseUrl, logging, etc
  ///
  ///
  static restClient(Dio dio) {
    return FlutterFeathersjsRest(dio);
  }

  /// Get the standalone socketio client
  ///
  /// This should be used when you want standalone socketio client
  ///
  /// You should configure your [socketio] client before passing to this method
  ///
  /// Configuring can mean adding autoConnect, baseUrl, ExtraHeaders, transport, logging, etc
  ///
  ///
  static socketioClient(IO.Socket io) {
    return FlutterFeathersjsSocketio(io);
  }

  ///
  /// Prepare a client for rest or socketio call.
  ///
  /// return [FlutterFeathersjsSocketio] or [FlutterFeathersjsRest], both are
  /// standalone client
  ///
  /// [serviceName] is the name of the service you want to call. Should defined on your server
  ///
  service(String serviceName) {
    /// pass the service to the standalone client and return it
    if (this.standaloneSocketio != null) {
      return this.standaloneSocketio!.service(serviceName);
    } else if (this.standaloneRest != null) {
      return this.standaloneRest!.service(serviceName);
    } else {
      throw new FeatherJsError(
          type: FeatherJsErrorType.CONFIGURATION_ERROR,
          error: "Client is not a valid feathers js client. ");
    }
  }

  /// Return authenticated user from secure storage
  ///
  /// If no user is authenticated, return {}
  Future<dynamic> user() async {
    return await SecureStorage.getUser();
  }
}
