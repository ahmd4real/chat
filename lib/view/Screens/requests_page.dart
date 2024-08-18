import 'dart:convert';
import 'package:chat/core/utils/constants.dart';
import 'package:chat/models/request_model.dart';
import 'package:chat/core/utils/utilities.dart';
import 'package:chat/view/Widgets/request_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestsPage extends StatefulWidget {
  RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  String firstName = '', profilePicture = '', bio = '';

  getParaData() async {
    firstName = await getData('firstName') ?? '';
    profilePicture = await getData('profilePicture') ?? '';
    bio = await getData('bio') ?? '';
  }

  List<Request> sameh = [];
  @override
  void initState() {
    super.initState();
    hubConnection.on("friendRequest", (List<Object?>? list) {
      sameh.add(Request.fromJson(list![0] as Map<String, dynamic>));
      setState(() {});
    });
    getParaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            if (sameh.isNotEmpty)
              for (int i = 0; i < 1; i++)
                 RequestWidget(
                    fullName: '', //sameh[i].firstName,
                    bio: '' //sameh[i].bio,

                    ),
            ElevatedButton(
                onPressed: () async {
                 //friendRequest(25);
                },
                child: const Text('Send Request'))
          ],
        ),
      ),
    );
  }

  
}
