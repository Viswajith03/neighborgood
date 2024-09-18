import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Message {
  final String message;
  final bool sent;
  final DateTime time;

  Message({
    required this.message,
    required this.sent,
    required this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'] ?? '',
      sent: json['sent'] ?? false,
      time: DateTime.parse(json['time']),
    );
  }
}

class ChatScreenPage extends StatefulWidget {
  final int recipientId;
  final String recipientName;
  final String recipientImage;

  const ChatScreenPage({
    super.key,
    required this.recipientId,
    required this.recipientName,
    required this.recipientImage,
    required recipientImageUrl,
  });

  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  List<Message> messages = [];
  late String currentUserImage;
  late IO.Socket socket;

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    getCurrentUserImage();
    initSocket();
  }

  void initSocket() {
    socket = IO.io('https://neighborgood.io', <String, dynamic>{
      'path': '/socket.io',
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('Connected to socket.io server with sid: ${socket.id}');
    });

    socket.on('disconnect', (_) {
      print('Disconnected from socket.io server');
    });

    socket.on('receive_message', (data) {
      print('Received message: $data');
      Message receivedMessage = Message.fromJson(data);
      setState(() {
        messages.add(receivedMessage);
      });
    });

    socket.on('connect_error', (error) {
      print('Socket connection error: $error');
    });

    socket.on('error', (error) {
      print('Socket error: $error');
    });
  }

  void sendMessage(String messageText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? senderUserId = prefs.getInt('userId');

    if (senderUserId == null) {
      print('Error: User ID not found in SharedPreferences.');
      return;
    }

    if (socket.connected) {
      Map<String, dynamic> messageData = {
        'recipient_user_id': widget.recipientId,
        'message': messageText,
        'sender_user_id': senderUserId,
        'sent': true,
        'time': DateTime.now().toIso8601String(),
      };

      print('Sending message: $messageData');
      socket.emit('message', messageData);
      setState(() {
        messages.add(Message(
          message: messageText,
          sent: true,
          time: DateTime.now(),
        ));
      });
    } else {
      print('Error: Socket not connected. Message cannot be sent.');
    }
  }

  Future<void> fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');

    if (userId == null || token == null) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://neighborgood.io/api/chat-history/$userId/${widget.recipientId}/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Message> fetchedMessages =
            data.map((item) => Message.fromJson(item)).toList();

        // Sort messages in ascending order of time (earliest to latest)
        fetchedMessages.sort((a, b) => a.time.compareTo(b.time));

        setState(() {
          messages = fetchedMessages;
        });
      } else {
        throw Exception('Failed to load chat messages');
      }
    } catch (error) {
      print('Error fetching chat messages: $error');
    }
  }

  Future<void> getCurrentUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserImage =
        prefs.getString('picture') ?? 'https://avatar.iran.liara.run/public';
  }

  Widget buildMessage(Message message) {
    bool isSentByUser = message.sent;
    String formattedTime = DateFormat('HH:mm').format(message.time);

    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              isSentByUser ? const Color(0xffA7C7E7) : const Color(0xffF4F0EF),
          borderRadius: isSentByUser
              ? const BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))
              : const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: const TextStyle(fontSize: 16, fontFamily: 'poppins'),
            ),
            const SizedBox(height: 5),
            Text(
              formattedTime,
              style: const TextStyle(
                  fontSize: 12, color: Colors.grey, fontFamily: 'poppins'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipientName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                var prevMessageDate =
                    index > 0 ? messages[index - 1].time : null;
                var messageDate = message.time;

                bool showDate = prevMessageDate == null ||
                    prevMessageDate.day != messageDate.day ||
                    prevMessageDate.month != messageDate.month ||
                    prevMessageDate.year != messageDate.year;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDate)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(messageDate),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    buildMessage(message),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        sendMessage(value.trim());
                        messageController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String messageText = messageController.text.trim();
                    if (messageText.isNotEmpty) {
                      sendMessage(messageText);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
