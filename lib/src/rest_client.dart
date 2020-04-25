import 'dart:async';

import 'package:dio/dio.dart';
import 'package:feathersjs/src/featherjs_client_base.dart';
import 'package:meta/meta.dart';

class RestClient extends FeathersJsClient {
  /////////////////////////////////////////////////////////////////////
  Dio dio;
  ////////////////////////////////////////////////////////////////////////

  RestClient({@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    //Setup Http client
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: extraHeaders,
    ));
  }

  Future<bool> authenticate(
      {strategy = "local", String email, String password}) async {
    Completer asyncTask = Completer<bool>();
    try {
      //Making http request to get auth token
      var response = await dio.post("/authentication",
          data: {"strategy": strategy, "email": email, "password": password});
      var token = response.data['accessToken'];
      dio.options.headers["Authorization"] = "Bearer $token";
      asyncTask.complete(true);
    } catch (e) {
      asyncTask.complete(false);
    }
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

  /* /// POST /serviceName
  /// Create multiple ressources simultaneously.
  /// NOT TESTED
  Future<Response<dynamic>> createBulk(
      {String serviceName, List<Map<String, dynamic>> data}) async {
    var response = await this.dio.post("/$serviceName", data: data);
    return response;
  } */

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

  /* /// PATCH /serviceName/_id
  /// Merge the existing data of multiple resources with the new data.
  /// Note: Multi options requred on server
  /// NOT TESTED
  Future<Response<dynamic>> patchBulk(
      {String serviceName,
      Map<String, dynamic> data,
      Map<String, dynamic> query}) async {
    var response = await this
        .dio
        .patch("/$serviceName", data: data, queryParameters: query);
    return response;
  } */

  /// DELETE /serviceName/_id
  /// Remove a single  resources:
  Future<Response<dynamic>> remove({String serviceName, objectId}) async {
    var response = await this.dio.delete(
          "/$serviceName/$objectId",
        );
    return response;
  }
/* 
  /// DELETE /serviceName
  /// Remove  multiple resources:
  /// NOT TESTED
  Future<Response<dynamic>> removeBulk(
      {String serviceName, Map<String, dynamic> query}) async {
    var response =
        await this.dio.delete("/$serviceName", queryParameters: query);
    return response;
  } */
}
