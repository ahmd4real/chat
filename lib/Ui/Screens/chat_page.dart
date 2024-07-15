import 'package:chatapp/Ui/Widgets/chat_bubble.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  static String id = 'chatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  final scrollCTRL = ScrollController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
            }

            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: kGreen,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 50, height: 50, child: Image.asset(kLogo)),
                      const Text('App')
                    ],
                  ),
                ),
                
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: scrollCTRL,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            return messagesList[index].id == email
                                ? ChatBubble(
                                    msgColor: kLightGreen,
                                    bottomLeft: 32,
                                    bottomRight: 0,
                                    align: Alignment.centerRight,
                                    messgae: messagesList[index],
                                  )
                                : ChatBubble(
                                    messgae: messagesList[index],
                                    msgColor: Colors.blue,
                                    bottomLeft: 0,
                                    align: Alignment.centerLeft,
                                    bottomRight: 32,
                                  );
                          }),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        onSubmitted: (data) {
                          messages.add({
                            kMessage: data,
                            'createdAt': DateTime.now(),
                            'id': email
                          });
                          controller.clear();
                          
                          scrollCTRL.animateTo(
                              

                              0, 
                              
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn);
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Send',
                          suffix: const Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 163, 255, 195),
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 163, 255, 195))),
                        ),
                      ),
                    )
                   
                  ],
                ));
          } else {
            return const Text('Loading......');
          }
        });
  }
}
