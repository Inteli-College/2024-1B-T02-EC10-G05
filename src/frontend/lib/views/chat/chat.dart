import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatPage extends StatefulWidget {
  final String userToken;
  final int requestId;

  const ChatPage({
    super.key,
    required this.userToken,
    required this.requestId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  late final types.User _user;
  late WebSocketChannel _channel;
  final AutoScrollController _scrollController = AutoScrollController();

  @override
  void initState() {
    super.initState();
    _user = types.User(id: widget.userToken == 'admin' ? 'admin-id' : '82091008-a484-4a89-ae75-a22bf8d6f3ac');
    _loadMessages();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    final token = widget.userToken;
    final url = 'wss://pilltrackr.cathena.io/ws/?token=$token';

    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(url));

      _channel.stream.listen((message) {
        final decodedMessage = json.decode(message);
        print('Received: $decodedMessage');
        _handleIncomingMessage(decodedMessage);
      }, onError: (error) {
        print('WebSocket error: $error');
        Future.delayed(Duration(seconds: 20), () => _connectWebSocket());
      }, onDone: () {
        print('WebSocket closed');
        Future.delayed(Duration(seconds: 10), () => _connectWebSocket());
      });
    } catch (e) {
      print('WebSocketChannelException: $e');
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> message) {
    final messageData = message['message'];
    if (messageData['RequestID'] == widget.requestId) {
      final isSentByUser = messageData['SentByUser'] ?? false;
      final author = types.User(id: isSentByUser ? _user.id : 'admin-id');

      final newMessage = types.TextMessage(
        author: author,
        createdAt: DateTime.parse(messageData['CreatedAt']).millisecondsSinceEpoch,
        id: messageData['ID'].toString(),
        text: messageData['Content'],
      );

      _addMessage(newMessage);
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    final wsMessage = {
      "request": widget.requestId,
      "content": message.text,
    };
    _channel.sink.add(json.encode(wsMessage));
  }

  void _loadMessages() async {
    final response = await http.get(
      Uri.parse('https://pilltrackr.cathena.io/api/request/${widget.requestId}/messages'),
      headers: {
        'Authorization': 'Bearer admin',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonMessages = json.decode(response.body);
      final messages = jsonMessages.map((json) {
        final isSentByUser = json['SentByUser'] ?? false;
        final author = types.User(id: isSentByUser ? _user.id : 'admin-id');

        return types.TextMessage(
          author: author,
          createdAt: DateTime.parse(json['CreatedAt']).millisecondsSinceEpoch,
          id: json['ID'].toString(),
          text: json['Content'],
        );
      }).toList();

      setState(() {
        _messages = messages.reversed.toList();
      });
    } else {
      print('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadMessages,
            ),
          ],
        ),
        body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
          scrollController: _scrollController,
        ),
      );
}