import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_feathersjs/src/constants.dart';
import 'package:flutter_feathersjs/src/featherjs_client_base.dart';
import 'package:flutter_feathersjs/src/utils.dart';
import 'package:meta/meta.dart';

///
///Feathers Js rest client for rest api call
///
///_______________________________________________
///_______________________________________________
///
///
/// `GENERAL NOTE 1`: Serialization and Deserialization are not supported.
///
/// You get exactly what feathers server send
///
class RestClient extends FlutterFeathersjs {
  ///Dio as http client
  Dio dio;
  Utils utils;
  bool dev = true;

  //Using singleton to ensure we use the same instance of it accross our app
  static final RestClient _restClient = RestClient._internal();
  factory RestClient() {
    return _restClient;
  }
  RestClient._internal();

  /// Initialize FlutterFeathersJs with the server baseUrl
  init({@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    utils = new Utils();

    //Setup Http client
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: extraHeaders,
    ));

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // Do something before request is sent
      //Adding stored token early with SharedPreferences
      var oldToken = await utils.getAccessToken();
      dio.options.headers["Authorization"] = "Bearer $oldToken";
      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    }, onResponse: (Response response) async {
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) async {
      // Do something with response error

      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        //Only send the error message from feathers js server not for Dio
        print(e.response);
        return dio.resolve(e.response.data);
        //return e.response.data; //continue
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        //By returning null, it means that error is from client
        //return null;
        return e;
      }
    }));
  }

  /// `Authenticate with JWT`
  ///
  /// The @params serviceName is use to test if the past token still validated
  Future<dynamic> reAuthenticate({String serviceName = "users"}) async {
    //AsyncTask manager
    Completer asyncTask = Completer<dynamic>();
    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": "UNKNOWN",
      "message": "An error occured"
    };

    //Getting the early stored rest access token and send the request by using it
    var oldToken = await utils.getAccessToken();

    ///If an oldToken exist really, try to chect it is still valided
    if (oldToken != null) {
      dio.options.headers["Authorization"] = "Bearer $oldToken";
      try {
        var response = await this
            .dio
            .get("/$serviceName", queryParameters: {"\$limit": 1});
        print(response);

        if (response.statusCode == 401) {
          print("jwt expired or jwt malformed");
          authResponse["error"] = true;
          authResponse["message"] = "jwt expired";
          authResponse["error_zone"] = Constants.JWT_EXPIRED_ERROR;
        } else if (response.statusCode == 200) {
          print("Jwt still validated");
          authResponse["error"] = false;
          authResponse["message"] = "Jwt still validated";
          authResponse["error_zone"] = Constants.NO_ERROR;
        } else {
          print("Unknown error");
          authResponse["error"] = true;
          authResponse["message"] = "Unknown error";
          authResponse["error_zone"] = Constants.UNKNOWN_ERROR;
        }
      } catch (e) {
        print("Unable to connect to the server");
        authResponse["error"] = true;
        authResponse["message"] = e;
        authResponse["error_zone"] = Constants.JWT_ERROR;
      }
    }

    ///No token is found
    else {
      print("No old token found. Must reAuth user");
      authResponse["error"] = true;
      authResponse["message"] = "No old token found. Must reAuth user";
      authResponse["error_zone"] = Constants.JWT_NOT_FOUND;
    }
    asyncTask.complete(authResponse);
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

    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": "UNKNOWN",
      "message": "An error occured"
    };

    try {
      //Making http request to get auth token
      var response = await dio.post("/authentication", data: {
        "strategy": strategy,
        "$userNameFieldName": userName,
        "password": password
      });
      //Check is auth is successfully before storing token
      if (response.data["code"] != null && response.data["code"] == 401) {
        //This is useful to display to end user why auth failed
        //With 401: it will be either Invalid credentials or strategy error
        if (response.data["message"] == "Invalid login") {
          authResponse["error_zone"] = Constants.INVALID_CREDENTIALS;
        } else {
          authResponse["error_zone"] = Constants.INVALID_STRATEGY;
        }
        authResponse["error"] = true;
        authResponse["message"] = response.data["message"];
      } else if (response.data['accessToken'] != null) {
        authResponse["error"] = false;
        authResponse["message"] = response.data["user"];
        authResponse["error_zone"] = Constants.NO_ERROR;

        //Storing the token
        utils.setAccessToken(token: response.data['accessToken']);
      } else {
        //Unknown error
        authResponse["error"] = true;
        authResponse["message"] = "Unknown error occured";
      }
    } catch (e) {
      //Error caught by Dio
      authResponse["error"] = true;
      authResponse["message"] = e;
      authResponse["error_zone"] = Constants.DIO_ERROR;
    }
    //Send response
    asyncTask.complete(authResponse);
    return asyncTask.future;
  }

  /// `GET /serviceName`
  ///
  /// Retrieves a list of all matching the `query` resources from the service
  ///
  Future<Response<dynamic>> find(
      {@required String serviceName,
      @required Map<String, dynamic> query}) async {
    var response;
    try {
      response = await this.dio.get("/$serviceName", queryParameters: query);
    } catch (e) {
      print("Error in rest::find");
      print(e);
    }
    return response;
  }

  /// `GET /serviceName/_id`
  ///
  /// Retrieve a single resource from the service with an `_id`
  ///
  Future<Response<dynamic>> get(
      {@required String serviceName, @required String objectId}) async {
    var response;
    try {
      response = response = await this.dio.get("/$serviceName/$objectId");
    } catch (e) {
      print("Error in rest::get");
      print(e);
    }
    return response;
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
  Future<Response<dynamic>> create(
      {@required String serviceName,
      @required Map<String, dynamic> data,
      containsFile = false,
      fileFieldName = "file",
      List<Map<String, String>> files}) async {
    Response<dynamic> response;

    if (!containsFile) {
      print('Dio.post without file');
      print("Service name is");
      print(serviceName);
      print("Data are: ");
      print(data);
      try {
        response = await this.dio.post("/$serviceName", data: data);
        print("Response from server is:");
        print(response.data);
        print(response);
      } catch (e) {
        print("Error in rest::create");
        print(e);
      }
    } else {
      print('Dio.post with file');
      print("Service name is");
      print(serviceName);
      print("nonFilesFieldsMap are: ");
      print(data);
      print("fileFieldName are: ");
      print(fileFieldName);
      print("files are: ");
      print(fileFieldName);
      FormData formData = await this.makeFormData(
          nonFilesFieldsMap: data, fileFieldName: fileFieldName, files: files);
      print("FormData built is: ");
      print(formData.fields);
      print(formData.files);
      try {
        response = await this.dio.post("/$serviceName", data: formData);
        print(response);
      } catch (e) {
        print("Error in rest::create::with:file");
        print(e);
      }
    }
    return response;
  }

  /// `PUT /serviceName/_id`
  ///
  /// Completely replace a single resource with the `_id = objectId`
  ///
  /// The below is important if you have file to upload [containsFile == true]
  ///@ `fileFieldName`: the file | files field which must be send to the server
  ///
  ///[@var files: a List map of {"filePath": the file path, "fileName": the file ame}]
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
  Future<Response<dynamic>> update(
      {@required String serviceName,
      @required String objectId,
      @required Map<String, dynamic> data,
      containsFile = false,
      fileFieldName = "file",
      List<Map<String, String>> files}) async {
    Response<dynamic> response;

    if (!containsFile) {
      try {
        response =
            await this.dio.put("/$serviceName" + "/$objectId", data: data);
      } catch (e) {
        print("Error in rest::update");
        print(e);
      }
    } else {
      FormData formData = await this.makeFormData(
          nonFilesFieldsMap: data, fileFieldName: fileFieldName, files: files);
      try {
        response = await this
            .dio
            .patch("/$serviceName" + "/$objectId", data: formData);
      } catch (e) {
        print("Error in rest::update::with:file");
        print(e);
      }
    }
    return response;
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
  Future<Response<dynamic>> patch(
      {@required String serviceName,
      @required String objectId,
      @required Map<String, dynamic> data,
      containsFile = false,
      fileFieldName = "file",
      List<Map<String, String>> files}) async {
    Response<dynamic> response;

    if (!containsFile) {
      try {
        response =
            await this.dio.patch("/$serviceName" + "/$objectId", data: data);
      } catch (e) {
        print("Error in rest::patch");
        print(e);
      }
    } else {
      FormData formData = await this.makeFormData(
          nonFilesFieldsMap: data, fileFieldName: fileFieldName, files: files);
      try {
        response = await this
            .dio
            .patch("/$serviceName" + "/$objectId", data: formData);
      } catch (e) {
        print("Error in rest::patch::with:file");
        print(e);
      }
    }

    return response;
  }

  /// `DELETE /serviceName/_id`
  ///
  /// Remove a single  resource with `_id = objectId `:
  Future<Response<dynamic>> remove(
      {@required String serviceName, @required String objectId}) async {
    var response;
    try {
      response = await this.dio.delete(
            "/$serviceName/$objectId",
          );
    } catch (e) {
      print("Error in rest::remove");
      print(e);
    }
    return response;
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
    print("Inside makeFormData");
    print("nonFilesFieldsMap is ");
    print(nonFilesFieldsMap);
    // Non file
    if (nonFilesFieldsMap != null) {
      print("nonFilesFieldsMap is not null ");
      nonFilesFieldsMap.forEach((key, value) {
        data["$key"] = value;
      });
    }
    print("nonFilesFieldsMap  withoud the files is ");
    print(data);
    var formData = FormData.fromMap(data);
    // // If single file is send
    // if (files != null && files.length == 1) {
    //   print("Receive signle file");
    //   var fileData = files[0];
    //   var file = await MultipartFile.fromFile(fileData["filePath"],
    //       filename: fileData["fileName"]);
    //   data["$fileFieldName"] = file;
    // } else if (files != null && files.length >= 1) {
    //   print("Receive multiple file");
    //   List filesList = [];
    //   for (var fileData in files) {
    //     var file = await MultipartFile.fromFile(fileData["filePath"],
    //         filename: fileData["fileName"]);
    //     filesList.add(file);
    //   }
    //   data["$fileFieldName"] = filesList;
    // }
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
