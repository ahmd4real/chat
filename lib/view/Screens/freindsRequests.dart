import 'dart:convert';

import 'package:chat/models/request_model.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Widgets/request_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FreindsRequests extends StatefulWidget {
  const FreindsRequests({super.key});

  @override
  State<FreindsRequests> createState() => _FreindsRequestsState();
}

class _FreindsRequestsState extends State<FreindsRequests> {
  List<Request> requests = [];
  late String token;
  void gettoken() async {
     token = await getData('jwt')??'';
  }

  @override
  void initState() {
    super.initState();
    getRequests(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        RequestWidget(
          fullName: requests[0].firstName,
          bio: requests[0].bio,
        )
      ],
    ));
  }

  Future<List<Request>> getRequests(String jwtToken) async {
    final url = Uri.parse('https://chat-app.runasp.net/api/FriendRequest');
    final response = await http.get(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      requests = body.map((dynamic item) => Request.fromJson(item)).toList();
      return requests;
    } else {
      throw Exception('Failed to load friend requests');
    }
  }
}
