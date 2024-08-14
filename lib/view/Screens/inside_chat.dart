import 'package:chat/constants.dart';
import 'package:chat/services/services.dart';
import 'package:chat/view/Widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/services/signalR.dart';

class InsideChat extends StatefulWidget {
  InsideChat({
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

  @override
  void initState() {
    super.initState();
    _loadMessages();

    
   signalRService.setupSignalR(kToken,);

    signalRService.onMessageReceived = (message) {
      setState(() {
        messagesList.insert(
          0,
          Message(
            msg: message.msg,
            sender: message.sender,
            timestamp: message.timestamp,
          ),
        );
      });
    };
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
    //final SignalRService signalRService =SignalRService();
    final message = controller.text.trim();
    if (message.isNotEmpty) {
      await signalRService.sendMessage(message, widget.chatId);
      setState(() {
        messagesList.insert(
          0,
          Message(
            msg: message,
            sender: widget.currentUserId.toString(), // Use currentUserId as the sender
            timestamp: DateTime.now().toString(),
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
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.arrow_back,
                size: 32,
              ),
              CircleAvatar(
                backgroundImage: widget.picUrl != null
                    ? NetworkImage(
                        'https://chat-app.runasp.net/${widget.picUrl!}')
                    : const AssetImage(kAvatar) as ImageProvider,
                radius: 24,
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: kWhite),
        backgroundColor: mainColor,
        title: Text(widget.fullName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: scrollCTRL,
              itemCount: messagesList.length,
              itemBuilder: (context, index) {
                final message = messagesList[index];
                final isSentByUser =
                    message.sender == widget.currentUserId.toString();

                return ChatBubble(
                  message: message,
                  isSentByUser: isSentByUser,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              controller: controller,
              onSubmitted: (_) => sendMessage(),
              decoration: InputDecoration(
                hintText: 'Send',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: mainColor),
                  onPressed: sendMessage,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: kGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: mainColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}