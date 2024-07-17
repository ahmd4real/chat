import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class API{
    Future<dynamic> post(
      {required String url,
      @required dynamic body,
      @required String? token}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    };

    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(body), headers: headers);
     if (response.statusCode == 200) {
      // Check if the response body is not empty
      if (response.body.isNotEmpty) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print("Empty response body");
        //throw Exception('Empty response body');
      }
    } else {
      print("Problem with status code ${response.statusCode}");
      // throw Exception(
      //     'Problem with status code ${response.statusCode}\nwith body${response.body}');
    }
  }
}