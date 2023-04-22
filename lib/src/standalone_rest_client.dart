import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'config/constants.dart';
import 'config/storage.dart';
import 'featherjs_client_base.dart';
import 'config/helper.dart';

/// @See https://github.com/Dahkenangnon/flutter_feathersjs.dart/issues/28 for the origin of this implementation
///
///
/// [FlutterFeathersjsRest] is a standalone rest client for flutter_feathersjs
///
/// Usage: Fully customize your http client, use seperate client
/// and a clean syntax. Customize client means you can set baseUrl, headers, interceptors, etc.
///
/// If the above usage is not your case, you can use [FlutterFeathersjs] instead
///
/// You can use it like this:
///
///
/// ```dart
/// import 'package:flutter_feathersjs/flutter_feathersjs.dart';
/// import 'package:dio/dio.dart';
///
/// FlutterFeathersjs client = FlutterFeathersjs();
/// Dio dio = Dio(BaseOptions(
///       baseUrl: baseUrl,
///       headers: extraHeaders
/// ));
///
/// client.configure(FlutterFeathersjs.restClient(dio));
///
/// client.service('messages').create({
///   text: 'A new message'
/// });
///
/// ```
///
/// {@macro response_format}
///
/// {@template flutter_feathersjs_rest_uploading_files}
/// Uploading file ?: Make sure the file field in your data Map, contains [FormData] type
///
/// unless, you file will not uploaded
///
/// {@endtemplate}
///
///
///--------------------------------------------
class FlutterFeathersjsRest extends FlutterFeathersjsClient {
  ///Dio as http client
  late Dio dio;

  /// Current service name
  String? serviceName;

  var jsonStorage = JsonStorage();

  FlutterFeathersjsRest(this.dio) {
    // configure dio interceptor to include jwt token in header for auth purpose
    this
        .dio
        .interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
          // Setting on every request the Bearer Token in the header
          var oldToken = await jsonStorage.getAccessToken(client: "rest");

          // This is necessary to send on every request the Bearer token to be authenticated
          this.dio.options.headers["Authorization"] = "Bearer $oldToken";
          return handler.next(options);
        }, onResponse: (response, handler) {
          // Return exactly what response feather send
          return handler.next(response);
        }, onError: (DioError e, handler) {
          if (!Foundation.kReleaseMode) {
            print("An error occured in Resclient");
            print(e.response);
          }

          return handler.next(e);
        }));
  }

  FlutterFeathersjsRest service(String serviceName) {
    this.serviceName = serviceName;
    return this;
  }

  /// `Authenticate with JWT`
  ///
  /// The [serviceName] is used to test if the last token still validated
  ///
  /// It so assume that your api has at least a service called  [serviceName]
  ///
  /// [serviceName] may be a service which required authentication
  Future<dynamic> reAuthenticate({String serviceName = "users"}) async {
    Completer asyncTask = Completer<dynamic>();
    FeatherJsError? featherJsError;
    bool isReauthenticate = false;

    //Getting the early stored rest access token and send the request by using it
    var oldToken = await jsonStorage.getAccessToken(client: "rest");

    ///If an oldToken exist really, try to chect if it is still validated
    this.dio.options.headers["Authorization"] = "Bearer $oldToken";
    try {
      // Try to retrieve the service which normaly don't accept anonimous user
      var response =
          await this.dio.get("/$serviceName", queryParameters: {"\$limit": 1});

      if (!Foundation.kReleaseMode) {
        print(response);
      }

      if (response.statusCode == 401) {
        if (!Foundation.kReleaseMode) {
          print("jwt expired or jwt malformed");
        }

        featherJsError = new FeatherJsError(
            type: FeatherJsErrorType.IS_JWT_EXPIRED_ERROR,
            error: "Must authenticate again because Jwt has expired");
      } else if (response.statusCode == 200) {
        if (!Foundation.kReleaseMode) {
          print("Jwt still validated");
          isReauthenticate = true;
        }
      } else {
        if (!Foundation.kReleaseMode) {
          print("Unknown error");
        }
        featherJsError = new FeatherJsError(
            type: FeatherJsErrorType.IS_UNKNOWN_ERROR,
            error:
                "Must authenticate again because unable to authenticate with the last token");
      }
    } on DioError catch (e) {
      // Error
      if (!Foundation.kReleaseMode) {
        print("Unable to connect to the server");
      }
      if (e.response != null) {
        featherJsError = new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR, error: e.response);
      } else {
        featherJsError = new FeatherJsError(
            type: FeatherJsErrorType.IS_UNKNOWN_ERROR, error: e);
      }
    }

    if (featherJsError != null) {
      //Complete with error
      asyncTask.completeError(featherJsError);
    } else {
      // Complete with success
      asyncTask.complete(isReauthenticate);
    }
    return asyncTask.future;
  }

  /// Authenticate with username & password
  ///
  /// [username] can be : email, phone, etc;
  ///
  /// But ensure that [userNameFieldName] is correct with your chosed [strategy]
  ///
  /// By default this will be `email`and the strategy `local`
  Future<dynamic> authenticate(
      {strategy = "local",
      required String? userName,
      required String? password,
      String userNameFieldName = "email"}) async {
    Completer asyncTask = Completer<dynamic>();

    /// Final response of the server
    late var response;
    FeatherJsError? featherJsError;

    try {
      //Making http request to get auth token
      response = await this.dio.post("/authentication", data: {
        "strategy": strategy,
        "$userNameFieldName": userName,
        "password": password
      });

      if (response.data['accessToken'] != null) {
        // Case when the world is perfect: no error
        await jsonStorage.saveAccessToken(response.data['accessToken'],
            client: "rest");
      } else {
        featherJsError = new FeatherJsError(
            type: FeatherJsErrorType.IS_UNKNOWN_ERROR,
            error: response.data["message"]);
      }
    } on DioError catch (e) {
      // Error in the request
      if (e.response != null) {
        if (e.response?.data["code"] == 401) {
          //This is useful to display to end user why auth failed
          //With 401: it will be either Invalid credentials or strategy error
          if (e.response?.data["message"] == "Invalid login") {
            featherJsError = new FeatherJsError(
                type: FeatherJsErrorType.IS_INVALID_CREDENTIALS_ERROR,
                error: e.response?.data["message"]);
          } else {
            featherJsError = new FeatherJsError(
                type: FeatherJsErrorType.IS_INVALID_STRATEGY_ERROR,
                error: e.response?.data["message"]);
          }
        } else {
          featherJsError = new FeatherJsError(
              type: FeatherJsErrorType.IS_UNKNOWN_ERROR, error: e);
        }
      } else {
        new FeatherJsError(
            error: e.message, type: FeatherJsErrorType.IS_CANNOT_SEND_REQUEST);
      }
    }

    if (featherJsError != null) {
      // Complete with error
      asyncTask.completeError(featherJsError);
    } else {
      // Send directly user if all thing is good
      asyncTask.complete(response.data["user"]);
    }

    return asyncTask.future;
  }

  /// `GET /serviceName`
  ///
  /// Retrieves a list of all matching the `query` resources from the service
  ///
  /// {@macro response_format}
  ///
  Future<dynamic> find(Map<String, dynamic> query) async {
    try {
      var response =
          await this.dio.get("/$serviceName", queryParameters: query);

      if (response.data != null) {
        return response.data;
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR,
            error: "Response body is empty");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw errorCode2FeatherJsError(e.response?.data);
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_UNKNOWN_ERROR, error: e.message);
      }
    }
  }

  /// `GET /serviceName/_id`
  ///
  /// Retrieve a single resource from the service with an `_id`
  ///
  /// {@macro response_format}
  ///
  Future<dynamic> get(String objectId) async {
    try {
      var response = await this.dio.get("/$serviceName/$objectId");

      if (response.data != null) {
        return response.data;
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR,
            error: "Response body is empty");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw errorCode2FeatherJsError(e.response?.data);
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_UNKNOWN_ERROR, error: e.message);
      }
    }
  }

  /// `POST /serviceName`
  ///
  /// Create a new resource with data.
  ///
  /// {@macro flutter_feathersjs_rest_uploading_files}
  ///
  /// {@macro response_format}
  ///
  Future<dynamic> create(Map<String, dynamic> data) async {
    var response;

    try {
      response = await this.dio.post("/$serviceName", data: data);
      if (response.data != null) {
        return response.data;
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR,
            error: "Response body is empty");
      }
    } on DioError catch (e) {
      throw new FeatherJsError(
          type: FeatherJsErrorType.IS_SERVER_ERROR, error: e.response);
    }
  }

  /// `PUT /serviceName/_id`
  ///
  /// Completely replace a single resource with the `_id = objectId`
  ///
  ///{@macro flutter_feathersjs_rest_uploading_files}
  ///
  ///{@macro response_format}
  ///
  ///
  Future<dynamic> update(String objectId, Map<String, dynamic> data) async {
    var response;
    try {
      response = await this.dio.put("/$serviceName" + "/$objectId", data: data);
      if (response.data != null) {
        return response.data;
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR,
            error: "Response body is empty");
      }
    } on DioError catch (e) {
      throw new FeatherJsError(
          type: FeatherJsErrorType.IS_SERVER_ERROR, error: e.response);
    }
  }

  /// `PATCH /serviceName/_id`
  ///
  /// Merge the existing data of a single (`_id = objectId`) resource with the new `data`
  ///
  /// {@macro flutter_feathersjs_rest_uploading_files}
  ///
  /// {@macro response_format}
  ///
  ///
  Future<dynamic> patch(String objectId, Map<String, dynamic> data) async {
    var response;
    try {
      response =
          await this.dio.patch("/$serviceName" + "/$objectId", data: data);
      if (response.data != null) {
        return response.data;
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR,
            error: "Response body is empty");
      }
    } on DioError catch (e) {
      throw new FeatherJsError(
          type: FeatherJsErrorType.IS_SERVER_ERROR, error: e.response);
    }
  }

  /// `DELETE /serviceName/_id`
  ///
  /// Remove a single  resource with `_id = objectId `:
  ///
  /// {@macro response_format}
  Future<dynamic> remove(String objectId) async {
    try {
      var response = await this.dio.delete(
            "/$serviceName/$objectId",
          );
      // Send only feathers js data
      if (response.data != null) {
        return response.data;
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR,
            error: "Response body is empty");
      }
    } on DioError catch (e) {
      // Throw an exception with e
      if (e.response != null) {
        throw errorCode2FeatherJsError(e.response?.data);
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_UNKNOWN_ERROR, error: e.message);
      }
    }
  }
}
