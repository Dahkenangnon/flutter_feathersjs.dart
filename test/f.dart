/* /**
 * @ Author: Carlos Henry Céspedes <chenryhabana205@gmail.com>
 * @ Create Time: 2020-02-18 18:13:47
 * @ Modified by: Carlos Henry Céspedes <chenryhabana205@gmail.com>
 * @ Modified time: 2020-02-18 19:39:08
 * @ Description:
 */

import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:feathers_socket_client/featherjs_events.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//https://projectmanager.cap.qva2world.com

class FeatherClient {
  final String serverUrl;
  final bool debug;

  FeatherClient({@required this.serverUrl, this.debug});
  String _currentEmail;
  String _currentPassword;
  bool isReady;

  IO.Socket _socket;
  IO.Socket get socket => _socket;
  EventBus _eventBus;
  String _accesToken;

  init() {
    _eventBus ??= EventBus();
    _socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
    });
    _socket.on('connect', (_) {
      if (debug) print('CONNECTED TO: $serverUrl');
      _eventBus.fire(OnConnect);
      isReady = true;
      if (_accesToken != null)
        _authWithJWT();
      else if (_currentEmail != null && _currentPassword != null) {
        authWithCredential(_currentEmail, _currentPassword);
      }
    });

    _socket.on('disconnect', (_) {
      if (debug) print('disconnect');
      _eventBus.fire(OnDisconnect);
      isReady = false;
    });
  }

  Stream<OnDisconnect> get onDisconnect {
    return _eventBus.on<OnDisconnect>();
  }

  Stream<OnConnect> get onConnect {
    return _eventBus.on<OnConnect>();
  }

  Future<bool> authWithCredential(String email, String password) async {
    Completer authFinished = Completer<bool>();
    socket.emitWithAck('create', [
      'authentication',
      <String, dynamic>{
        'strategy': 'local',
        'email': email,
        'password': password
      }
    ], ack: (authResult) {
      try {
        _accesToken = authResult[1]['accessToken'];
        _currentEmail = email;
        _currentPassword = password;
        if (debug) print(_accesToken);
        authFinished.complete(true);
      } catch (e) {
        authFinished.complete(false);
      }
    });
    return authFinished.future;
  }

  _authWithJWT() {
    socket.emitWithAck('create', [
      'authentication',
      <String, dynamic>{
        'strategy': 'jwt',
        'accessToken': _accesToken,
      }
    ], ack: (dataResponse) {
      if (debug) print(dataResponse);
    });
  }

  Future<Map<String, dynamic>> find(String collection,
      {Map<String, dynamic> query}) {
    Completer c = Completer<Map<String, dynamic>>();
    _socket.emitWithAck("find", [collection, if (query != null) query],
        ack: (response) {
      if (debug) print(response[1]);
      c.complete(response[1]); // a is an array with the results
    });
    return c.future;
  }

  Future<List<T>> findAll<T>(String collection, Function deserializeFunction,
      {Map<String, dynamic> query}) {
    Completer c = Completer<List<T>>();
    socket.emitWithAck("find", [collection, if (query != null) query],
        ack: (response) {
      if (debug) print(response[1]);
      var dynamicList = response[1]['data'];
      List<T> deserializedList = dynamicList
          .map<T>((element) => deserializeFunction(element) as T)
          .toList();
      c.complete(deserializedList); // a is an array with the results
    });
    return c.future;
  }

  Future<bool> remove(String collection, {Map<String, dynamic> query}) {
    Completer c = Completer<bool>();
    _socket.emitWithAck("remove", [collection, if (query != null) query],
        ack: (response) {
      if (debug) print(response[1]);
      c.complete(true); // a is an array with the results
    });
    return c.future;
  }

  Future<bool> add<T>(String collection, {Map<String, dynamic> query}) {
    Completer c = Completer<bool>();
    _socket.emitWithAck("create", [collection, if (query != null) query],
        ack: (response) {
      if (debug) print(response[1]);
      c.complete(true); // a is an array with the results
    });
    return c.future;
  }

  Future<bool> update<T>(String collection,
      {String id, Map<String, dynamic> query}) {
    Completer c = Completer<bool>();
    _socket.emitWithAck("update", [collection, id, if (query != null) query],
        ack: (response) {
      if (debug) print(response);
      c.complete(true); // a is an array with the results
    });
    return c.future;
  }

  Stream<T> listenTo<T>(
      {@required String collectionName, Function deserializeFunction}) {
    _socket.on('$collectionName created', (newData) {
      T object = deserializeFunction(newData);
      if (debug) print('NEW $collectionName: $object');
      _eventBus.fire(object);
    });

    return _eventBus.on<T>();
  }

  Stream<List<T>> listenToList<T>(
      {@required String collectionName, Function deserializeFunction}) {
    List<T> currentList = List();

    //Get init element
    findAll<T>(collectionName, deserializeFunction).then((onResult) {
      currentList = onResult;
      _eventBus.fire(currentList);
      _socket.on('$collectionName created', (newData) {
        T object = deserializeFunction(newData);
        if (debug) print('NEW $collectionName: $object');
        currentList.add(object);
        _eventBus.fire(currentList);
      });

      _socket.on('$collectionName updated', (newData) {
        // T object = deserializeFunction(newData);
        // print('NEW $collectionName: $object');
        // currentList.add(object);
        // _eventBus.fire(currentList);
        findAll<T>(collectionName, deserializeFunction).then((onResult) {
          currentList = onResult;
          _eventBus.fire(currentList);
        });
      });

      _socket.on('$collectionName removed', (newData) {
        T object = deserializeFunction(newData);
        if (debug) print('NEW $collectionName: $object');
        currentList.remove(object);
        _eventBus.fire(currentList);
      });
    });

    return _eventBus.on<List<T>>();
  }
}
 */
