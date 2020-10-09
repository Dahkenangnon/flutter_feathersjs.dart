import 'package:flutter_feathersjs/src/featherjs_client_base.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:meta/meta.dart';

class SocketioClient extends FlutterFeathersjs {
  IO.Socket _socket;

  SocketioClient(
      {@required String baseUrl, Map<String, dynamic> extraHeaders}) {
    _socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': extraHeaders,
      'autoConnect': false,
    });
    _socket.connect();
  }
}
