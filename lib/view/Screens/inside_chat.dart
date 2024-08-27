import 'package:chat/core/utils/constants.dart';
import 'package:chat/core/utils/utilities.dart';
import 'package:chat/services/services.dart';
import 'package:chat/view/Screens/home_page.dart';
import 'package:chat/view/Widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/services/signalR.dart';

class InsideChat extends StatefulWidget {
  const InsideChat({
    super.key,
    required this.chatId,
    this.picUrl,
    required this.fullName,
    required this.currentUserId,
  });

  final String chatId;
  final String fullName;
  final String? picUrl;
  final int currentUserId;

  @override
  _InsideChatState createState() => _InsideChatState();
}

class _InsideChatState extends State<InsideChat> {
  TextEditingController controller = TextEditingController();
  final scrollCTRL = ScrollController();
  List<Message> messagesList = [];
  final SignalRService signalRService = SignalRService();
  String typingSetState = '';
  String userOnlineStatus = '';
  bool tapped = false;

  @override
  void initState() {
    super.initState();

    _loadMessages();
print('init is working');
    signalRService.setupSignalR(
      kToken,
      onMessageReceived: (message) {
        print(' hello from  onMessageReceived: $message');
        setState(() {
          messagesList.insert(
            0,
            Message(
              msg: message.msg,
              sender: message.sender,
              timestamp: message.timestamp,
              messageDate: message.messageDate,
            ),
          );

          _scrollToBottom();
          setState(() {
            typingSetState = '';
          });
        });
      },
      onTyping: () {
        setState(() {
          typingSetState = 'Typing....';
        });
      },
    );

    isTyping(widget.chatId);
  }

  Future<void> isTyping(String chatId) async {
    await signalRService.isTyping(chatId);
  }

  Future<void> isOnline(String chatId) async {
    await signalRService.isOnline(chatId);
  }

  Future<void> _loadMessages() async {
    try {
      List<Message> fetchedMessages =
          await fetchMessages(widget.chatId, kToken);
      setState(() {
        messagesList.addAll(fetchedMessages);
        messagesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _scrollToBottom() {
    scrollCTRL.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    signalRService.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final message = controller.text.trim();
    if (message.isNotEmpty) {
      final String timeNow = getTimeNow();
      await signalRService.sendMessage(message, widget.chatId);
      setState(() {
        tapped = true;
        messagesList.insert(
          0,
          Message(
            msg: message,
            sender: widget.currentUserId.toString(),
            timestamp: DateTime.now().toString(),
            messageDate: timeNow,
          ),
        );
      });
      controller.clear();
      _scrollToBottom();
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * 0.125,
        iconTheme: IconThemeData(color: kWhite),
        backgroundColor: background,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.picUrl != null
                  ? NetworkImage(
                      'https://chat-app.runasp.net/${widget.picUrl!}')
                  : const AssetImage(kAvatar) as ImageProvider,
              radius: 32,
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.fullName),
                Text(
               
                  '$typingSetState $userOnlineStatus', //typing ? 'typing...' : '',
                  style: TextStyle(
                    color: kGreen,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Divider(height: 1, color: searchContent),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: scrollCTRL,
              itemCount: messagesList.length,
              itemBuilder: (context, index) {
                final message = messagesList[index];
                final isSentByUser = message.sender.toString() ==
                    widget.currentUserId.toString();

                return ChatBubble(
                  tapped: tapped,
                  message: message,
                  isSentByUser: isSentByUser,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: TextField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  signalRService.isTyping(widget.chatId);
                }
              },
              cursorColor: searchContent,
              controller: controller,
              onSubmitted: (_) => sendMessage(),
              decoration: InputDecoration(
                hintText: 'Send',
                hintStyle: TextStyle(color: searchContent),
                fillColor: searchBack,
                focusColor: searchBack,
                filled: true,
                prefixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions_rounded,
                      color: searchContent,
                      size: 32,
                    )),
                suffixIcon: IconButton(
                  icon: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: mainColor,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.asset(kIcon),
                      )),
                  onPressed: () {
                   
                    sendMessage();
                  },
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: searchBack),
                  borderRadius: BorderRadius.circular(32),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: searchBack),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: searchBack),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
