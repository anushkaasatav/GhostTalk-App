// socket_service.dart
import 'dart:io';
import 'dart:convert';

class SocketService {
  static Socket? _socket;
  static Function(String message)? onMessageReceived;

  static void connect() async {
    try {
      _socket = await Socket.connect('127.0.0.1', 8080);
      _socket!.listen((data) {
        final message = utf8.decode(data);
        if (onMessageReceived != null) {
          onMessageReceived!(message);
        }
      });
    } catch (e) {
      print("❌ Could not connect to server: $e");
    }
  }

  static void send(String message) {
    if (_socket != null) {
      _socket!.write(message);
    }
  }
}

