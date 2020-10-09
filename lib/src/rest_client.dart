import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_feathersjs/src/featherjs_client_base.dart';
import 'package:meta/meta.dart';

/// Feathers Js rest client
class RestClient extends FlutterFeathersjs {
  ///Dio as http client
  Dio dio;

  RestClient({@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    //Setup Http client
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: extraHeaders,
    ));

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // Do something before request is sent
      //Adding stored token early with sembast
      var oldToken = await this.utils.getRestAccessToken();
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
        return e.response.data; //continue
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // print(e.request);
        // print(e.message);
        //By returning null, it means that error is from client
        return null;
      }
    }));
  }

  Future<dynamic> reAuthenticate({String serviceName = "users"}) async {
    //AsyncTask manager
    Completer asyncTask = Completer<dynamic>();
    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": "UNKNOWN",
      "message": "An error occured"
    };

    //Getting the early sotored rest access token and send the request by using it
    var oldToken = await this.utils.getRestAccessToken();

    //If an oldToken exist really
    if (oldToken != null) {
      dio.options.headers["Authorization"] = "Bearer $oldToken";
      var response =
          await find(serviceName: "$serviceName", query: {"\$limit": 1});

      if (response.statusCode == 401) {
        print("jwt expired or jwt malformed");
        authResponse["error"] = true;
        authResponse["message"] = "jwt expired";
        authResponse["error_zone"] = "JWT_EXPIRED_ERROR";
      } else if (response.statusCode == 200) {
        print("Jwt still validated");
        authResponse["error"] = false;
        authResponse["message"] = "Jwt still validated";
        authResponse["error_zone"] = "NO_ERROR";
      } else {
        print("Unknown error");
        authResponse["error"] = true;
        authResponse["message"] = "Unknown error";
        authResponse["error_zone"] = "UNKNOWN_ERROR";
      }
    } else {
      print("No old token found. Must reAuth user");
      authResponse["error"] = true;
      authResponse["message"] = "No old token found. Must reAuth user";
      authResponse["error_zone"] = "JWT_NOT_FOUND";
    }
    asyncTask.complete(authResponse);
    return asyncTask.future;
  }

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
          authResponse["error_zone"] = "INVALID_CREDENTIALS";
        } else {
          authResponse["error_zone"] = "INVALID_STRATEGY";
        }
        authResponse["error"] = true;
        authResponse["message"] = response.data["message"];
      } else if (response.data['accessToken'] != null) {
        authResponse["error"] = false;
        authResponse["message"] = response.data["user"];
        authResponse["error_zone"] = "NO_ERROR";

        //Store the authenticated user
        await this
            .utils
            .setAuthenticatedFeathersUser(user: response.data['user']);
        //Storing the token
        await this
            .utils
            .setRestAccessToken(token: response.data['accessToken']);
      } else {
        //Unknown error
        authResponse["error"] = true;
        authResponse["message"] = "Unknown error occured";
      }
    } catch (e) {
      //Error caught by Dio
      authResponse["error"] = true;
      authResponse["message"] = e;
      authResponse["error_zone"] = "DIO_ERROR";
    }
    //Send response
    asyncTask.complete(authResponse);
    return asyncTask.future;
  }

  /// GET /serviceName
  /// Retrieves a list of all matching resources from the service
  Future<Response<dynamic>> find(
      {String serviceName, Map<String, dynamic> query}) async {
    var response = await this.dio.get("/$serviceName", queryParameters: query);
    return response;
  }

  /// GET /serviceName/_id
  /// Retrieve a single resource from the service.
  Future<Response<dynamic>> get({String serviceName, objectId}) async {
    var response = await this.dio.get("/$serviceName/$objectId");
    return response;
  }

  /// POST /serviceName
  /// Create a new resource with data.
  Future<Response<dynamic>> create(
      {String serviceName, Map<String, dynamic> data}) async {
    var response = await this.dio.post("/$serviceName", data: data);
    return response;
  }

  /// PUT /serviceName/_id
  /// Completely replace a single resource.
  Future<Response<dynamic>> update(
      {String serviceName, objectId, Map<String, dynamic> data}) async {
    var response =
        await this.dio.put("/$serviceName" + "/$objectId", data: data);
    return response;
  }

  /// PATCH /serviceName/_id
  /// Merge the existing data of a single resources with the new data.
  /// NOT TESTED
  Future<Response<dynamic>> patch(
      {String serviceName, objectId, Map<String, dynamic> data}) async {
    var response =
        await this.dio.patch("/$serviceName" + "/$objectId", data: data);
    return response;
  }

  /// DELETE /serviceName/_id
  /// Remove a single  resources:
  Future<Response<dynamic>> remove({String serviceName, objectId}) async {
    var response = await this.dio.delete(
          "/$serviceName/$objectId",
        );
    return response;
  }
}
