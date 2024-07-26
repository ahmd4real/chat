import 'package:chat/view/Widgets/request_widget.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
        children: [
          for (int i=0;i<20;i++)
          RequestWidget()
        ],
        ),
      ),
    );
  }
}