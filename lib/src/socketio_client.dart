import 'dart:async';

import 'package:feathersjs/src/featherjs_client_base.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:meta/meta.dart';

class SocketioClient extends FeathersJsClient {
  /////////////////////////////////////////////////////////////////////
  IO.Socket _socket;
  String accesToken;
  bool dev = true;
  ////////////////////////////////////////////////////////////////////////

  /// Constructor
  /// Connect anonymously to the _socket server througth web _socket
  SocketioClient(
      {@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    _socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': extraHeaders,
      //'autoConnect': false,
    });
    //_socket.connect();

    if (dev) {
      _socket.on('connect', (_) {
        print("Socket connection established");
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
      _socket.on('disconnect', (_) => print("Disconnected..."));
      _socket.on('error', (_) => print("An error occured"));
      _socket.on('reconnect', (_) => print("Reconnected"));
      _socket.on('reconnect_error', (_) => print("Reconnection error..."));
      _socket.on(
          'reconnect_attempt', (_) => print("Attempting a reconnection"));
      _socket.on('reconnect_failed', (_) => print("A reconnection failed"));
      _socket.on('reconnecting', (_) => print("Reconnecting..."));
    }
  }

  /// EMIT create authentication
  /// Authenticate the _socket connection
  Future<bool> authenticate({
    String email,
    String password,
  }) async {
    Completer asyncTask = Completer<bool>();
    _socket.emitWithAck('create', [
      'authentication',
      <String, dynamic>{
        'strategy': 'local',
        'email': email,
        'password': password
      }
    ], ack: (authResult) {
      try {
        accesToken = authResult[1]['accessToken'];
        asyncTask.complete(true);
      } catch (e) {
        asyncTask.complete(false);
      }
    });
    return asyncTask.future;
  }

  /// EMIT find serviceName
  /// Retrieves a list of all matching resources from the service
  Future<dynamic> emitFind(
      {String serviceName, Map<String, dynamic> query}) async {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("find", [serviceName, query], ack: (response) {
      asyncTask.complete(response[1]); 
    });
    return asyncTask.future;
  }

  /// EMIT create serviceName
  /// Create new ressource
  Future<dynamic> emitCreate({String serviceName, Map<String, dynamic> data}) {
    Completer  asyncTask = Completer<dynamic>();
    _socket.emitWithAck("create", [serviceName, data], ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// EMIT update serviceName
  /// Update a  ressource
  Future<dynamic> emitUpdate(
      {String serviceName, objectId, Map<String, dynamic> data}) {
    Completer  asyncTask = Completer<dynamic>();
    _socket.emitWithAck("update", [serviceName, objectId, data],
        ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// EMIT get serviceName
  /// Retrieve a single  ressource
  Future<dynamic> emitGet({String serviceName, objectId}) {
    Completer  asyncTask = Completer<dynamic>();
    _socket.emitWithAck("get", [serviceName, objectId], ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// EMIT patch serviceName
  ///Merge the existing data of a single or multiple resources with the new data
  Future<dynamic> emitPatch(
      {String serviceName, objectId, Map<String, dynamic> data}) {
    Completer  asyncTask = Completer<dynamic>();
    _socket.emitWithAck("patch", [serviceName, objectId, data],
        ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// EMIT patch serviceName
  ///Merge the existing data of a single or multiple resources with the new data
  Future<dynamic> emitRemove({String serviceName, objectId}) {
    Completer  asyncTask = Completer<dynamic>();
    _socket.emitWithAck("remove", [serviceName, objectId], ack: (response) {
      asyncTask.complete(response[1]);
    });
    return asyncTask.future;
  }

  /// Listen to create method call
  ///Get the last created ressource
  onCreated({String serviceName, Function callback}) {
    _socket.on("$serviceName created", (data) {
      callback(data);
    });
  }

  /// Listen to update method
  ///Get the last updated ressource
  onUpdated({String serviceName, Function callback}) {
    _socket.on("$serviceName updated", (data) {
      callback(data);
    });
  }

  /// Listen to remove method call
  ///Get the last deleted ressource
  onRemoved({String serviceName, Function callback}) {
    _socket.on("$serviceName removed", (data) {
      callback(data);
    });
  }
}
