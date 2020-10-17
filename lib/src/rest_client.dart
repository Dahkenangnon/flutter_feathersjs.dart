import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_feathersjs/src/featherjs_client_base.dart';
import 'package:flutter_feathersjs/src/utils.dart';
import 'package:meta/meta.dart';

import 'constants.dart';

/// Feathers Js rest client for rest api call
class RestClient extends FlutterFeathersjs {
  ///Dio as http client
  Dio dio;
  Utils utils;
  Constants isCode;

  //Using singleton to ensure we the same instance of it
  static final RestClient _restClient = RestClient._internal();
  factory RestClient() {
    return _restClient;
  }
  RestClient._internal();

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
      //Adding stored token early with sembast
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
        // print(e.response.data);
        // print(e.response.headers);
        // print(e.response.request);
        //Only send the error message from feathers js server not for Dio
        print(e.response.data);
        return e.response.data; //continue
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // print(e.request);
        // print(e.message);
        //By returning null, it means that error is from client
        //return null;
        return e;
      }
    }));
  }

  //Authenticate with jwt
  Future<dynamic> reAuthenticate({String serviceName = "users"}) async {
    //AsyncTask manager
    Completer asyncTask = Completer<dynamic>();
    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": "UNKNOWN",
      "message": "An error occured"
    };

    //Getting the early sotored rest access token and send the request by using it
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
          authResponse["error_zone"] = isCode..JWT_EXPIRED_ERROR;
        } else if (response.statusCode == 200) {
          print("Jwt still validated");
          authResponse["error"] = false;
          authResponse["message"] = "Jwt still validated";
          authResponse["error_zone"] = isCode.NO_ERROR;
        } else {
          print("Unknown error");
          authResponse["error"] = true;
          authResponse["message"] = "Unknown error";
          authResponse["error_zone"] = isCode.UNKNOWN_ERROR;
        }
      } catch (e) {
        print("Unable to connect to the server");
        authResponse["error"] = true;
        authResponse["message"] = e;
        authResponse["error_zone"] = isCode.JWT_ERROR;
      }
    }

    ///No token is found
    else {
      print("No old token found. Must reAuth user");
      authResponse["error"] = true;
      authResponse["message"] = "No old token found. Must reAuth user";
      authResponse["error_zone"] = isCode.JWT_NOT_FOUND;
    }
    asyncTask.complete(authResponse);
    return asyncTask.future;
  }

  //Authenticate with email & password
  Future<dynamic> authenticate(
      {strategy = "local", String email, String password}) async {
    Completer asyncTask = Completer<dynamic>();

    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": "UNKNOWN",
      "message": "An error occured"
    };

    try {
      //Making http request to get auth token
      var response = await dio.post("/authentication",
          data: {"strategy": strategy, "email": email, "password": password});
      //Check is auth is successfully before storing token
      if (response.data["code"] != null && response.data["code"] == 401) {
        //This is useful to display to end user why auth failed
        //With 401: it will be either Invalid credentials or strategy error
        if (response.data["message"] == "Invalid login") {
          authResponse["error_zone"] = isCode.INVALID_CREDENTIALS;
        } else {
          authResponse["error_zone"] = isCode.INVALID_STRATEGY;
        }
        authResponse["error"] = true;
        authResponse["message"] = response.data["message"];
      } else if (response.data['accessToken'] != null) {
        authResponse["error"] = false;
        authResponse["message"] = response.data["user"];
        authResponse["error_zone"] = isCode.NO_ERROR;

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
      authResponse["error_zone"] = isCode.DIO_ERROR;
    }
    //Send response
    asyncTask.complete(authResponse);
    return asyncTask.future;
  }

  /// GET /serviceName
  /// Retrieves a list of all matching resources from the service
  Future<Response<dynamic>> find(
      {String serviceName, Map<String, dynamic> query}) async {
    var response;
    try {
      response = await this.dio.get("/$serviceName", queryParameters: query);
    } catch (e) {
      print("Error in rest::find");
      print(e);
    }
    return response;
  }

  /// GET /serviceName/_id
  /// Retrieve a single resource from the service.
  Future<Response<dynamic>> get({String serviceName, objectId}) async {
    var response;
    try {
      response = response = await this.dio.get("/$serviceName/$objectId");
    } catch (e) {
      print("Error in rest::get");
      print(e);
    }
    return response;
  }

  /// POST /serviceName
  /// Create a new resource with data.
  Future<Response<dynamic>> create(
      {String serviceName, Map<String, dynamic> data}) async {
    var response;
    try {
      response = response = await this.dio.post("/$serviceName", data: data);
    } catch (e) {
      print("Error in rest::create");
      print(e);
    }
    return response;
  }

  /// PUT /serviceName/_id
  /// Completely replace a single resource.
  Future<Response<dynamic>> update(
      {String serviceName, objectId, Map<String, dynamic> data}) async {
    var response;
    try {
      response = await this.dio.put("/$serviceName" + "/$objectId", data: data);
    } catch (e) {
      print("Error in rest::update");
      print(e);
    }
    return response;
  }

  /// PATCH /serviceName/_id
  /// Merge the existing data of a single resources with the new data.
  /// NOT TESTED
  Future<Response<dynamic>> patch(
      {String serviceName, objectId, Map<String, dynamic> data}) async {
    var response;
    try {
      response =
          await this.dio.patch("/$serviceName" + "/$objectId", data: data);
    } catch (e) {
      print("Error in rest::patch");
      print(e);
    }
    return response;
  }

  /// DELETE /serviceName/_id
  /// Remove a single  resources:
  Future<Response<dynamic>> remove({String serviceName, objectId}) async {
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
}
