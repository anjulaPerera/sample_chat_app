// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Color lightBlue = const Color(0xFF1AA3A3);
  Color black = const Color(0xFF191919);
  TextEditingController msgInputController = TextEditingController();

  late IO.Socket socket;

  @override
  void initState() {
    socket = IO.io(
        'http://localhost:4000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        body: Column(children: [
          Expanded(
            flex: 9,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const MessageItem(
                  sentByMe: false,
                );
              },
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: lightBlue,
              controller: msgInputController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: lightBlue,
                  ),
                  child: IconButton(
                      onPressed: () {
                        sendMessage(msgInputController.text);
                        msgInputController.text = "";
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ))
        ]));
  }

  void sendMessage(String text) {
    var messageJson = {"message": text, "sentByMe": socket.id};
    socket.emit('message', messageJson);
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.sentByMe});
  final bool sentByMe;
  @override
  Widget build(BuildContext context) {
    Color lightBlue = const Color(0xFF1AA3A3);
    Color white = Colors.white;
    return Align(
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: sentByMe ? lightBlue : white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Hello',
                  style: TextStyle(
                    color: sentByMe ? white : lightBlue,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '1:10 AM',
                  style: TextStyle(
                    color: (sentByMe ? white : lightBlue).withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            )));
  }
}
