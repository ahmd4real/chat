import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';




// The location of the SignalR Server.
// Import the library.





//COLORS
Color kGreen=const  Color.fromARGB(255, 70, 110, 84);
Color kBlack=const Color.fromARGB(255, 0, 0, 0);
Color kLightGreen=const Color(0xFF4CAF50);
Color kButtonsColor=const Color(0xff7e97f3);



//PATHS
const String kLogo='assets/images/logo.png';
const String  kAvatar='assets/images/avatar.png';


//KEYS
String kMessage='msg';
String kCreatedAt='createdAt';
String kMessageId='id';


late HubConnection hubConnection;

const String  baseUrl='https://chat-app.runasp.net/api/Accounts/';