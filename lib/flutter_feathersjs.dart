library flutter_feathersjs;

import 'package:flutter_feathersjs/src/rest_client.dart';
import 'package:flutter_feathersjs/src/socketio_client.dart';
import 'package:meta/meta.dart';

class FlutterFeathersjs {
  /////////////////////////////////////////////////////////////////////
  RestClient rest;
  SocketioClient scketio;

  ////////////////////////////////////////////////////////////////////////

//Using singleton
  static final FlutterFeathersjs _flutterFeathersjs =
      FlutterFeathersjs._internal();
  factory FlutterFeathersjs() {
    return _flutterFeathersjs;
  }
  FlutterFeathersjs._internal();

  //intialize both rest and scoketio client, base url and headers.
  config({@required String baseUrl, Map<String, dynamic> extraHeaders}) async {
    rest = new RestClient(baseUrl: baseUrl, extraHeaders: extraHeaders);

    //Auth only by rest, so we must call auth or reAuth from rest before use scketio
    var oldToken = await this.rest.utils.getRestAccessToken();
    Map<String, dynamic> scketIOExtraHeaders = {
      "Authorization": "Bearer $oldToken"
    };
    scketio =
        new SocketioClient(baseUrl: baseUrl, extraHeaders: scketIOExtraHeaders);
  }

  /// Authenticate client
  Future<dynamic> authenticate(
      {@required String email,
      @required String password,
      String client = "rest"}) async {
    return await rest.authenticate(email: email, password: password);
  }
}
