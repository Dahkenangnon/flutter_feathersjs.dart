import 'dart:async';

import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter_feathersjs/src/constants.dart';
import 'package:flutter_feathersjs/src/featherjs_client_base.dart';
import 'package:flutter_feathersjs/src/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:meta/meta.dart';
import 'package:event_bus/event_bus.dart';

///
///
///Socketio client for the realtime communication
///
///_______________________________________________
///_______________________________________________
///
///
/// `GENERAL NOTE 1`: If no error is occured, you will get an array
///
/// Feathers data can be retrieve by doing
///
/// `response[1]: => Feathers SocketIO `Method` Response Format`
///
/// When an error occured, you will get a Json or Map object
///
/// The format of the last one is according to what error occured on feather js server
///
/// `GENERAL NOTE 2`: You cannot send file through this realtime client, please use rest client
///
class SocketioClient extends FlutterFeathersjs {
  IO.Socket _socket;

  Utils utils;

  EventBus eventBus = EventBus();

  //Using singleton
  static final SocketioClient _socketioClient = SocketioClient._internal();
  factory SocketioClient() {
    return _socketioClient;
  }

  SocketioClient._internal();

  /// Initialize the realtime (socketio) connection
  init({@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    _socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      //'extraHeaders': extraHeaders,
      'autoConnect': true,
    });
    //_socket.connect();

    utils = new Utils();

    _socket.on('connect', (_) {
      eventBus.fire(Connected());
    });

    _socket.on('disconnect', (_) {
      eventBus.fire(DisConnected());
    });

    // Print debug infos only in debug mode
    if (!Foundation.kReleaseMode) {
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
      _socket.on('disconnect', (_) {});
      _socket.on('error', (_) => print("An error occured"));
      _socket.on('reconnect', (_) => print("Reconnected"));
      _socket.on('reconnect_error', (_) => print("Reconnection error..."));
      _socket.on(
          'reconnect_attempt', (_) => print("Attempting a reconnection"));
      _socket.on('reconnect_failed', (_) => print("A reconnection failed"));
      _socket.on('reconnecting', (_) => print("Reconnecting..."));
    }
  }

  ///
  /// Authenticate the user with realtime connection
  ///
  /// @WARNING This function must be call afther auth with rest is OK
  ///
  ///Otherwise, you cannot be able to use socketio client because it won't be authed on the server
  ///
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
      if (!Foundation.kReleaseMode) {
        print("Receive response from server on JWT request");
        print(dataResponse);
      }

      //Check whether auth is OK
      if (dataResponse is List) {
        if (!Foundation.kReleaseMode) {
          print("Authentication process is ok with JWT");
        }

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
        if (!Foundation.kReleaseMode) {
          print("Authentication process failed with JWT");
        }
        //Auth is not ok
        authResponse["error"] = true;
        authResponse["message"] = dataResponse;
        authResponse["error_zone"] = Constants.AUTH_WITH_JWT_FAILED;
      }
      asyncTask.complete(authResponse);
    });

    return asyncTask.future;
  }

  /// `EMIT find serviceName`
  ///
  /// Retrieves a list of all matching `query` resources from the service
  ///
  /// NOTE: If no error is occured, you will get an array
  ///
  /// Feathers data can be retrieve by doing
  ///
  /// `response[1]: => Feathers SocketIO Find Response Format`
  ///
  /// When an error occured, you will get a Json or Map object
  ///
  /// The format of the last one is according to what error occured on feather js server
  ///
  Future<dynamic> find(
      {@required String serviceName,
      @required Map<String, dynamic> query}) async {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("find", [serviceName, query], ack: (response) {
      asyncTask.complete(response);
    });
    return asyncTask.future;
  }

  /// `EMIT create serviceName`
  ///
  /// Create new ressource
  ///
  /// `NOTE`: If no error is occured, you will get an array
  ///
  /// Feathers data can be retrieve by doing
  ///
  /// `response[1]: => Feathers SocketIO Create Response Format`
  ///
  /// When an error occured, you will get a Json or Map object
  ///
  /// The format of the last one is according to what error occured on feather js server
  ///
  Future<dynamic> create(
      {@required String serviceName, @required Map<String, dynamic> data}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("create", [serviceName, data], ack: (response) {
      asyncTask.complete(response);
    });
    return asyncTask.future;
  }

  /// `EMIT update serviceName`
  ///
  /// Update a  ressource
  ///
  /// `NOTE`: If no error is occured, you will get an array
  ///
  /// Feathers data can be retrieve by doing
  ///
  /// `response[1]: => Feathers SocketIO Update Response Format`
  ///
  /// When an error occured, you will get a Json or Map object
  ///
  /// The format of the last one is according to what error occured on feather js server
  ///
  Future<dynamic> update(
      {@required String serviceName,
      @required String objectId,
      @required Map<String, dynamic> data}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("update", [serviceName, objectId, data],
        ack: (response) {
      asyncTask.complete(response);
    });
    return asyncTask.future;
  }

  /// `EMIT get serviceName`
  ///
  /// NOTE: If no error is occured, you will get an array
  ///
  /// Feathers data can be retrieve by doing
  ///
  /// `response[1]: => Feathers SocketIO Get Response Format`
  ///
  /// When an error occured, you will get a Json or Map object
  ///
  /// The format of the last one is according to what error occured on feather js server
  ///
  Future<dynamic> get(
      {@required String serviceName, @required String objectId}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("get", [serviceName, objectId], ack: (response) {
      asyncTask.complete(response);
    });
    return asyncTask.future;
  }

  /// `EMIT patch serviceName`
  ///
  ///Merge the existing data of a single or multiple resources with the new data
  ///
  /// NOTE: If no error is occured, you will get an array
  ///
  /// Feathers data can be retrieve by doing
  ///
  /// `response[1]: => Feathers SocketIO Patch Response Format`
  ///
  /// When an error occured, you will get a Json or Map object
  ///
  /// The format of the last one is according to what error occured on feather js server
  ///
  Future<dynamic> patch(
      {@required String serviceName,
      @required String objectId,
      @required Map<String, dynamic> data}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("patch", [serviceName, objectId, data],
        ack: (response) {
      asyncTask.complete(response);
    });
    return asyncTask.future;
  }

  /// `EMIT remove serviceName`
  ///
  /// Delete a ressource on the server
  ///
  /// NOTE: If no error is occured, you will get an array
  ///
  /// Feathers data can be retrieve by doing
  ///
  /// `response[1]: => Feathers SocketIO Remove Response Format`
  ///
  /// When an error occured, you will get a Json or Map object
  ///
  /// The format of the last one is according to what error occured on feather js server
  ///
  Future<dynamic> remove({@required String serviceName, String objectId}) {
    Completer asyncTask = Completer<dynamic>();
    _socket.emitWithAck("remove", [serviceName, objectId], ack: (response) {
      asyncTask.complete(response);
    });
    return asyncTask.future;
  }

  /// Listen to `On updated | patched | created | removed serviceName`
  ///
  /// The updated and patched events will be published with the callback data,
  ///  when a service update or patch method calls back successfully.
  ///
  /// NOTE: The data you will get from the `StreamSubscription`
  /// is exactly what feathers send `On updated | patched serviceName`
  ///
  Stream<T> listen<T>(
      {@required String serviceName, @required Function fromJson}) {
    _socket.on('$serviceName updated', (updatedData) {
      T object = fromJson(updatedData);
      eventBus.fire(object);
    });
    _socket.on('$serviceName patched', (patchedData) {
      T object = fromJson(patchedData);
      eventBus.fire(object);
    });

    _socket.on('$serviceName removed', (removedData) {
      T object = fromJson(removedData);
      eventBus.fire(object);
    });

    _socket.on('$serviceName created', (createdData) {
      T object = fromJson(createdData);
      eventBus.fire(object);
    });
    return eventBus.on<T>();
  }
}
