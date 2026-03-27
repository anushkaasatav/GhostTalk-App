import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String username;
  const ChatScreen({super.key, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    socket = IO.io('http://localhost:8080', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print("🟢 Connected to server");
      socket.emit("joined", widget.username);
    });

    socket.on("message", (data) {
      if (data is String && data.startsWith("IMG:")) {
        final bytes = base64Decode(data.substring(4));
        setState(() {
          _messages.add({'type': 'image', 'data': bytes});
        });

        Future.delayed(const Duration(seconds: 10), () {
          setState(() {
            _messages.removeWhere(
              (msg) => msg['type'] == 'image' && msg['data'] == bytes,
            );
          });
        });
      } else {
        setState(() {
          _messages.add({'type': 'text', 'data': data});
        });
      }
    });

    socket.onDisconnect((_) => print("🔴 Disconnected"));
  }

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final msg = "${widget.username}: ${_controller.text.trim()}";
    socket.emit("message", msg);
    setState(() {
      _messages.add({
        'type': 'text',
        'data': "🧍 You: ${_controller.text.trim()}"
      });
      _controller.clear();
    });
  }

  Future<void> sendImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;

      // Image preview confirmation before sending
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("📸 Send this snap?", style: TextStyle(color: Colors.white)),
          content: Image.memory(bytes),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Send", style: TextStyle(color: Colors.greenAccent)),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      final base64Image = base64Encode(bytes);
      socket.emit("message", "IMG:$base64Image");

      setState(() {
        _messages.add({'type': 'image', 'data': bytes});
      });

      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          _messages.removeWhere(
            (msg) => msg['type'] == 'image' && msg['data'] == bytes,
          );
        });
      });
    }
  }

  void onScreenshotPressed() {
    setState(() {
      _messages.add({
        'type': 'text',
        'data': "⚠️ Your chat was screenshot!"
      });
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('GhostTalk - ${widget.username}'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: sendImage,
          ),
          IconButton(
            icon: const Icon(Icons.warning_amber),
            onPressed: onScreenshotPressed,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg['type'] == 'text') {
                  return Text(msg['data'],
                      style: const TextStyle(color: Colors.white));
                } else if (msg['type'] == 'image') {
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("⚠️ Screenshot Detected"),
                          content: const Text("Taking screenshots is not allowed!"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            )
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Image.memory(msg['data'], width: 200),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
