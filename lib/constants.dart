import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';




// The location of the SignalR Server.
// Import the library.





//COLORS
//Color kGreen=const  Color.fromARGB(255, 70, 110, 84);
//Color kBlack=const Color.fromARGB(255, 0, 0, 0);
Color kLightGreen=const Color(0xFF4CAF50);
Color kButtonsColor=const Color(0xff7e97f3);

Color noColor= const Color.fromARGB(0, 0, 0, 0);

Color kBlack=const Color(0xff020407);
Color  mainColor=const Color(0xff669156);
//Color kWhite=const Color(0xffEFF3ED);
Color kGrey=const Color(0xffAFBCC6);
Color kDarkGrey=const Color(0xff333333);


//PATHS
const String kLogo='assets/images/logo.png';
const String  kAvatar='assets/images/avatar.png';
const String kIcon='assets/images/paper-plane.png';

const String font='Almarai';
const String font2='IBMPlexSansArabic';
//KEYS
String kMessage='msg';
String kCreatedAt='createdAt';
String kMessageId='id';


late HubConnection hubConnection;

const String  baseUrl='https://chat-app.runasp.net/api/Accounts/';

late String kToken;

bool typing=false;


//new colors 

Color background=const Color (0xff062125);
Color kGreen=const Color (0xff00b14a);
Color kWhite=const Color(0xffefecec);
Color navBarBackground=const Color(0xff7e97f3);
Color kBlue=const Color(0xff0070d5);
Color chatBubble2=const Color(0xff3d4747);
Color timeAgoColor=const Color(0xff5e6c6f);


Color searchBack=const Color(0xff223037);
Color searchContent=const Color(0xff455054);
