import 'dart:async';

import 'package:flutter_feathersjs/src/constants.dart';
import 'package:flutter_feathersjs/src/featherjs_client_base.dart';
import 'package:flutter_feathersjs/src/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:meta/meta.dart';
import 'package:event_bus/event_bus.dart';

///Socketio client for the realtime communication
class SocketioClient extends FlutterFeathersjs {
  IO.Socket _socket;
  bool dev = true;
  Utils utils;
  EventBus eventBus = EventBus();

  //Using singleton
  static final SocketioClient _socketioClient = SocketioClient._internal();
  factory SocketioClient() {
    return _socketioClient;
  }
  SocketioClient._internal();

  ///Anonymous connection
  ///

  init({@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    _socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      //'extraHeaders': extraHeaders,
      'autoConnect': true,
    });
    //_socket.connect();

    utils = new Utils();

    if (true) {
      print("-----Dev printing start----");

      _socket.on('connect', (_) {
        print("Socket connection established");
        eventBus.fire(Connected());
      });

      _socket.on('connect_error', (e) {
        print("Connection error");
        print(e);
      });
      _socket.on('connect_timeout', (data) {
        print("Timeout error");
        print(data);
      });
      _socket.on('connecting', (_) => print("Connecting..."));
      _socket.on('disconnect', (_) {
        eventBus.fire(DisConnected());
      });
      _socket.on('error', (_) => print("An error occured"));
      _socket.on('reconnect', (_) => print("Reconnected"));
      _socket.on('reconnect_error', (_) => print("Reconnection error..."));
      _socket.on(
          'reconnect_attempt', (_) => print("Attempting a reconnection"));
      _socket.on('reconnect_failed', (_) => print("A reconnection failed"));
      _socket.on('reconnecting', (_) => print("Reconnecting..."));
      print("-----Dev printing end----");
    }
  }

  ///This function must be call afther auth with rest is OK
  Future<dynamic> authWithJWT() async {
    //Get the existant accessToken
    //This cause you to call auth on rest before call this.
    String token = await utils.getAccessToken();

    Map<String, dynamic> authResponse = {
      "error": true,
      "error_zone": Constants.UNKNOWN_ERROR,
      "message": "An error occured"
    };
    Completer asyncTask = Completer<dynamic>();

    _socket.emitWithAck('create', [
      'authentication',
      <String, dynamic>{
        'strategy': 'jwt',
        'accessToken': token,
      }
    ], ack: (dataResponse) {
      print("Receive response from server on JWT request");
      if (dev) print(dataResponse);

      //Check whether auth is OK
      if (dataResponse is List) {
        if (dev) print("Is array");
        //Auth is ok
        var resp = dataResponse[1];
        authResponse["error"] = false;
        authResponse["message"] = resp["user"]; // This contains the user data
        authResponse["error_zone"] = Constants.AUTH_WITH_JWT_SUCCEED;

        //Every emit or on will be authed
        this._socket.io.options['extraHeaders'] = {
          'Authorization': "Bearer $token"
        };
      } else {
        if (dev) print("Is not list");
        //Auth is not ok
        authResponse["error"] = true;
        authResponse["message"] = dataResponse;
        authResponse["error_zone"] = Constants.AUTH_WITH_JWT_FAILED;
      }
      asyncTask.complete(authResponse);
    });

    return asyncTask.future;
  }

  /// EMIT find serviceName
  /// Retrieves a list of all matching resources from the service
  Future<dynamic> find({String serviceName, Map<String, dynamic> query}) async {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("find", [serviceName, query], ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// EMIT create serviceName
  /// Create new ressource
  Future<dynamic> create({String serviceName, Map<String, dynamic> data}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("create", [serviceName, data], ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// EMIT update serviceName
  /// Update a  ressource
  Future<dynamic> update(
      {String serviceName, objectId, Map<String, dynamic> data}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("update", [serviceName, objectId, data],
        ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// EMIT get serviceName
  /// Retrieve a single  ressource
  Future<dynamic> get({String serviceName, objectId}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("get", [serviceName, objectId], ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// EMIT patch serviceName
  ///Merge the existing data of a single or multiple resources with the new data
  Future<dynamic> patch(
      {String serviceName, objectId, Map<String, dynamic> data}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("patch", [serviceName, objectId, data],
        ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// EMIT patch serviceName
  ///Merge the existing data of a single or multiple resources with the new data
  Future<dynamic> remove({String serviceName, objectId}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("remove", [serviceName, objectId], ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }
}
