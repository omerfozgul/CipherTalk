import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/local_storage.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final String loggedUser;

  ChatScreen({required this.loggedUser});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, String>> messages = [];
  final TextEditingController messageTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final LocalStorage storage; // LocalStorage sınıfı için bir değişken

  @override
  void initState() {
    super.initState();
    storage = LocalStorage(user: widget.loggedUser); // storage'ı başlat
    loadMessages();
  }

  void loadMessages() {
    storage.loadChat().then((loadedMessages) {
      if (mounted) {
        setState(() {
          messages = loadedMessages;
        });
      }
    }).catchError((error) {
      // Hata yönetimi
      print('Mesajlar yüklenirken bir hata oluştu: $error');
    });
  }

  void onSendMessage() {
    if (messageTextController.text.isNotEmpty) {
      final newMessage = {
        'text': messageTextController.text,
        'sender': widget.loggedUser,
      };
      messageTextController.clear();
      setState(() {
        messages.add(newMessage);
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      storage.saveChat(messages).catchError((error) {
        // Hata yönetimi
        print('Mesajlar kaydedilirken bir hata oluştu: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              storage.saveChat(messages).then((_) {
                // Mesajlar kaydedildikten sonra önceki ekrana dön
                Navigator.pop(context);
              });
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isUserMessage =
                      messages[index]['sender'] == widget.loggedUser;
                  return Align(
                    alignment: isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.lightBlueAccent
                              : Colors.grey[300],
                          borderRadius: isUserMessage
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0))
                              : BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)),
                        ),
                        child: Text(
                          messages[index]['text']!,
                          style: TextStyle(
                              color: isUserMessage
                                  ? Colors.white
                                  : Colors.black54),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        // Mesaj yazılırken yapılacak işlemler
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: onSendMessage,
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
