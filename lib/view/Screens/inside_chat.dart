import 'package:chat/constants.dart';
import 'package:chat/view/Widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class InsideChat extends StatelessWidget {
  InsideChat({super.key});

  TextEditingController controller = TextEditingController();

  final scrollCTRL = ScrollController();
  final messagesList = [];
  final email = '';
  var messages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kGreen,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 50, height: 50, child: Image.asset(kAvatar)),
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

                  scrollCTRL.animateTo(0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn);
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Send',
                  suffix: const Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  hintStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: const BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide:  BorderSide(
                          color: kButtonsColor
                ),
              ),
            )
        )
        )],
        ));
  }
}
