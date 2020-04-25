library feathersjs;

import 'package:feathersjs/src/rest_client.dart';
import 'package:feathersjs/src/socketio_client.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeathersJs {
  /////////////////////////////////////////////////////////////////////
  RestClient restClient;
  SocketioClient socketioClient;
  ////////////////////////////////////////////////////////////////////////

  static final FeathersJs _feathersJs = FeathersJs._internal();

  factory FeathersJs() {
    return _feathersJs;
  }
  FeathersJs._internal();

  init({@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    restClient = new RestClient(baseUrl: baseUrl, extraHeaders: extraHeaders);
    socketioClient =
        new SocketioClient(baseUrl: baseUrl, extraHeaders: extraHeaders);
  }

  /// Authenticate on or both feathers client
  /// {..., client: 'rest' or 'socketio' or 'all' ,...}
  Future<bool> authenticate(
      {@required String email,
      @required String password,
      String client = "rest"}) async {
    var authSuccess = false;
    if (client == "rest") {
      authSuccess =
          await restClient.authenticate(email: email, password: password);
    } else if (client == "socketio") {
      authSuccess =
          await socketioClient.authenticate(email: email, password: password);
    } else if (client == "all") {
      var authSuccessRest =
          await restClient.authenticate(email: email, password: password);
      var authSuccessSocket =
          await socketioClient.authenticate(email: email, password: password);
      authSuccess = authSuccessSocket & authSuccessRest;
    }
    return authSuccess;
  }
}
