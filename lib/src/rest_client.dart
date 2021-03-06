import 'dart:async';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart' as Foundation;

import 'featherjs_client_base.dart';
import 'helper.dart';

///Feathers Js rest client for rest api call
/// `Note`: You get exactly what feathers server send
class RestClient extends FlutterFeathersjsBase {
  ///Dio as http client
  Dio dio;
  FeatherjsHelper utils;
  bool dev = true;

  //Using singleton to ensure we use the same instance of it accross our app
  static final RestClient _restClient = RestClient._internal();
  factory RestClient() {
    return _restClient;
  }
  RestClient._internal();

  /// Initialize FlutterFeathersJs with the server baseUrl
  init({@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    utils = new FeatherjsHelper();

    //Setup Http client
    this.dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: extraHeaders,
    ));

    this
        .dio
        .interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
          // Setting on every request the Bearer Token in the header
          var oldToken = await utils.getAccessToken();
          this.dio.options.headers["Authorization"] = "Bearer $oldToken";
          return handler.next(options); //continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: return `dio.resolve(response)`.
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: return `dio.reject(dioError)`
        }, onResponse: (response, handler) {
          // Return exactly what response feather send
          return handler.next(response); // continue
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: return `dio.reject(dioError)`
        }, onError: (DioError e, handler) {
          // Do something with response error
          if (!Foundation.kReleaseMode) {
            print("An error occured in Resclient");
            print(e.response);
          }
          return handler.next(e);
          //continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: return `dio.resolve(response)`.
        }));
  }

  /// `Authenticate with JWT`
  ///
  /// The @params serviceName is used to test if the last token still validated
  ///
  /// It so assume that your api has at least a service called  `$serviceName`
  ///
  /// `$serviceName` may be a service which required authentication
  Future<dynamic> reAuthenticate({String serviceName = "users"}) async {
    Completer asyncTask = Completer<dynamic>();
    FeatherJsError featherJsError;
    bool isReauthenticate = false;

    //Getting the early stored rest access token and send the request by using it
    var oldToken = await utils.getAccessToken();

    ///If an oldToken exist really, try to chect if it is still validated
    if (oldToken != null) {
      this.dio.options.headers["Authorization"] = "Bearer $oldToken";
      try {
        // Try to retrieve the service which normaly don't accept anonimous user
        var response = await this
            .dio
            .get("/$serviceName", queryParameters: {"\$limit": 1});

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
      } catch (e) {
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
    }

    ///No token is found
    else {
      if (!Foundation.kReleaseMode) {
        print("No old token found. Must reAuth user");
      }
      featherJsError = new FeatherJsError(
          type: FeatherJsErrorType.IS_JWT_TOKEN_NOT_FOUND_ERROR,
          error: "No old token found. Must reAuth user");
    }

    if (featherJsError != null) {
      asyncTask.completeError(featherJsError); //Complete with error
    } else {
      // Complete with success
      asyncTask.complete(isReauthenticate);
    }
    return asyncTask.future;
  }

  /// Authenticate with username & password
  ///
  /// @params `username` can be : email, phone, etc;
  ///
  /// But ensure that `userNameFieldName` is correct with your chosed `strategy`
  ///
  /// By default this will be `email`and the strategy `local`
  Future<dynamic> authenticate(
      {strategy = "local",
      @required String userName,
      @required String password,
      String userNameFieldName = "email"}) async {
    Completer asyncTask = Completer<dynamic>();

    /// Final response of the server
    var response;
    FeatherJsError featherJsError;

    try {
      //Making http request to get auth token
      response = await this.dio.post("/authentication", data: {
        "strategy": strategy,
        "$userNameFieldName": userName,
        "password": password
      });

      if (response.data['accessToken'] != null) {
        // Case when the world is perfect: no error
        utils.setAccessToken(token: response.data['accessToken']);
      } else {
        featherJsError = new FeatherJsError(
            type: FeatherJsErrorType.IS_UNKNOWN_ERROR,
            error: response.data["message"]);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(":: Error from the request");
        print(e.response.data);
        print(e.response.headers);
      } else {
        print(":: Unable to send the request");
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }

      // Error in the request
      if (e.response != null) {
        if (e.response.data["code"] == 401) {
          //This is useful to display to end user why auth failed
          //With 401: it will be either Invalid credentials or strategy error
          if (e.response.data["message"] == "Invalid login") {
            featherJsError = new FeatherJsError(
                type: FeatherJsErrorType.IS_INVALID_CREDENTIALS_ERROR,
                error: e.response.data["message"]);
          } else {
            featherJsError = new FeatherJsError(
                type: FeatherJsErrorType.IS_INVALID_STRATEGY_ERROR,
                error: e.response.data["message"]);
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
      asyncTask.completeError(featherJsError); // Complete with error
    } else {
      asyncTask.complete(
          response.data["user"]); // Send directly user if all thing is good
    }

    return asyncTask.future;
  }

  /// `GET /serviceName`
  ///
  /// Retrieves a list of all matching the `query` resources from the service
  ///
  Future<dynamic> find(
      {@required String serviceName,
      @required Map<String, dynamic> query}) async {
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
    } catch (e) {
      if (e.response != null) {
        throw errorCode2FeatherJsError(e.response.data);
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
  Future<dynamic> get(
      {@required String serviceName, @required String objectId}) async {
    try {
      var response = await this.dio.get("/$serviceName/$objectId");

      if (response.data != null) {
        return response.data;
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR,
            error: "Response body is empty");
      }
    } catch (e) {
      if (e.response != null) {
        throw errorCode2FeatherJsError(e.response.data);
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
  /// The below is important if you have file to upload [containsFile == true]
  ///
  ///
  ///
  ///@ `fileFieldName`: the file | files field which must be send to the server
  ///
  ///[@var files: a List map of {"filePath": the file path, "fileName": the file ame}]
  //      Or if multiple files
  ///     var files =
  ///     [
  ///
  ///     { 'filePath': '/data/shared/epatriote_logo.png', 'fileName': 'epatriote_logo.png' },
  ///     { 'filePath': '/data/shared/epatriote_bg.png', 'fileName': 'epatriote_bg.png' },
  ///     { 'filePath': '/data/shared/epatriote_log_dark.png', 'fileName': 'epatriote_log_dark.png' }
  ///
  ///     ]
  ///
  ///
  ///
  Future<dynamic> create(
      {@required String serviceName,
      @required Map<String, dynamic> data,
      containsFile = false,
      fileFieldName = "file",
      List<Map<String, String>> files}) async {
    var response;

    if (!containsFile) {
      try {
        response = await this.dio.post("/$serviceName", data: data);
        if (response.data != null) {
          return response.data;
        } else {
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_SERVER_ERROR,
              error: "Response body is empty");
        }
      } catch (e) {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR, error: e.response);
      }
    } else {
      // Making form Data
      FormData formData;
      try {
        formData = await this.makeFormData(
            nonFilesFieldsMap: data,
            fileFieldName: fileFieldName,
            files: files);
      } catch (e) {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_FORM_DATA_ERROR, error: e);
      }

      // Making request
      try {
        response = await this.dio.post("/$serviceName", data: formData);
        if (response.data != null) {
          return response.data;
        } else {
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_SERVER_ERROR,
              error: "Response body is empty");
        }
      } catch (e) {
        if (e.response != null) {
          throw errorCode2FeatherJsError(e.response.data);
        } else {
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_UNKNOWN_ERROR, error: e.message);
        }
      }
    }
  }

  /// `PUT /serviceName/_id`
  ///
  /// Completely replace a single resource with the `_id = objectId`
  ///
  /// The below is important if you have file to upload [containsFile == true]
  ///@ `fileFieldName`: the file | files field which must be send to the server
  ///
  ///[@var files: a List map of {"filePath": the file path, "fileName": the file ame}]
  ///      Or if multiple files
  ///     var files =
  ///     [
  ///
  ///     { 'filePath': '/data/shared/epatriote_logo.png', 'fileName': 'epatriote_logo.png' },
  ///     { 'filePath': '/data/shared/epatriote_bg.png', 'fileName': 'epatriote_bg.png' },
  ///     { 'filePath': '/data/shared/epatriote_log_dark.png', 'fileName': 'epatriote_log_dark.png' }
  ///
  ///     ]
  ///
  ///
  ///
  Future<dynamic> update(
      {@required String serviceName,
      @required String objectId,
      @required Map<String, dynamic> data,
      containsFile = false,
      fileFieldName = "file",
      List<Map<String, String>> files}) async {
    var response;

    if (!containsFile) {
      // Try making request with no file field
      try {
        response =
            await this.dio.put("/$serviceName" + "/$objectId", data: data);
        if (response.data != null) {
          return response.data;
        } else {
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_SERVER_ERROR,
              error: "Response body is empty");
        }
      } catch (e) {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR, error: e.response);
      }
    } else {
      // Building form data
      FormData formData;
      try {
        formData = await this.makeFormData(
            nonFilesFieldsMap: data,
            fileFieldName: fileFieldName,
            files: files);
      } catch (e) {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_FORM_DATA_ERROR, error: e);
      }

      // Try making request with  file field
      try {
        response = await this
            .dio
            .patch("/$serviceName" + "/$objectId", data: formData);
        if (response.data != null) {
          return response.data;
        } else {
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_SERVER_ERROR,
              error: "Response body is empty");
        }
      } catch (e) {
        if (e.response != null) {
          throw errorCode2FeatherJsError(e.response.data);
        } else {
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_UNKNOWN_ERROR, error: e.message);
        }
      }
    }
  }

  /// `PATCH /serviceName/_id`
  ///
  /// Merge the existing data of a single (`_id = objectId`) resource with the new `data`
  ///
  /// The below is important if you have file to upload [containsFile == true]
  ///
  ///
  ///
  ///@ `fileFieldName`: the file | files field which must be send to the server
  ///
  ///[@var files: a List map of {"filePath": the file path, "fileName": the file ame}]
  ///
  ///     // Or if multiple files
  ///     var files =
  ///     [
  ///
  ///     { 'filePath': '/data/shared/epatriote_logo.png', 'fileName': 'epatriote_logo.png' },
  ///     { 'filePath': '/data/shared/epatriote_bg.png', 'fileName': 'epatriote_bg.png' },
  ///     { 'filePath': '/data/shared/epatriote_log_dark.png', 'fileName': 'epatriote_log_dark.png' }
  ///
  ///     ]
  ///
  ///
  ///
  Future<dynamic> patch(
      {@required String serviceName,
      @required String objectId,
      @required Map<String, dynamic> data,
      containsFile = false,
      fileFieldName = "file",
      List<Map<String, String>> files}) async {
    var response;

    if (!containsFile) {
      // Try making request with no file field
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
      } catch (e) {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_SERVER_ERROR, error: e.response);
      }
    } else {
      // Try building form data
      FormData formData;
      try {
        formData = await this.makeFormData(
            nonFilesFieldsMap: data,
            fileFieldName: fileFieldName,
            files: files);
      } catch (e) {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_FORM_DATA_ERROR, error: e);
      }

      // Try to send response as feathers send or throw an error
      try {
        response = await this
            .dio
            .patch("/$serviceName" + "/$objectId", data: formData);
        if (response.data != null) {
          return response.data;
        } else {
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_SERVER_ERROR,
              error: "Response body is empty");
        }
      } catch (e) {
        if (e.response != null) {
          throw errorCode2FeatherJsError(e.response.data);
        } else {
          throw new FeatherJsError(
              type: FeatherJsErrorType.IS_UNKNOWN_ERROR, error: e.message);
        }
      }
    }
  }

  /// `DELETE /serviceName/_id`
  ///
  /// Remove a single  resource with `_id = objectId `:
  Future<dynamic> remove(
      {@required String serviceName, @required String objectId}) async {
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
    } catch (e) {
      // Throw an exception with e
      if (e.response != null) {
        throw errorCode2FeatherJsError(e.response.data);
      } else {
        throw new FeatherJsError(
            type: FeatherJsErrorType.IS_UNKNOWN_ERROR, error: e.message);
      }
    }
  }

  ///@params `nonFilesFieldsMap`: other field non file
  ///
  ///
  ///@params `fileFieldName`: the file | files field which must be send to the server
  ///
  ///@var `files`: a List map of `{"filePath": the file path, "fileName": the file name with extension}`
  ///
  /// `Example: { 'filePath': '/data/shared/epatriote_logo.png', 'fileName': 'epatriote_logo.png' }`
  ///
  ///     // Or if multiple files
  ///     var files =
  ///     [
  ///
  ///     { 'filePath': '/data/shared/epatriote_logo.png', 'fileName': 'epatriote_logo.png' },
  ///     { 'filePath': '/data/shared/epatriote_bg.png', 'fileName': 'epatriote_bg.png' },
  ///     { 'filePath': '/data/shared/epatriote_log_dark.png', 'fileName': 'epatriote_log_dark.png' }
  ///
  ///     ]
  ///
  ///
  ///
  Future<FormData> makeFormData(
      {Map<String, dynamic> nonFilesFieldsMap,
      @required fileFieldName,
      List<Map<String, String>> files}) async {
    Map<String, dynamic> data = {};

    // logging
    if (!Foundation.kReleaseMode) {
      print("Building formData before sending it to feathers");
    }

    // Non file
    if (nonFilesFieldsMap != null) {
      print("Adding non null nonFilesFieldsMap");
      nonFilesFieldsMap.forEach((key, value) {
        data["$key"] = value;
      });
    }

    // Build now the request as a form data
    var formData = FormData.fromMap(data);
    for (var fileData in files) {
      formData.files.add(MapEntry(
        fileFieldName,
        await MultipartFile.fromFile(fileData["filePath"],
            filename: fileData["fileName"]),
      ));
    }

    return formData;
  }
}
