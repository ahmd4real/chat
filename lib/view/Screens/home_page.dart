import 'package:chat/services/services.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/profile_page.dart';
import 'package:chat/view/Widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
static String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  void navigateScreens(int index) {
   setState(() {
     currentIndex = index;
   });
  }
  List<Widget>pages=const [
   Home(),
   ProfilePage(),
  ];
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavBar(onTabChange: (index)=> navigateScreens(index),),
      body: pages[currentIndex],
    
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Center(
          child: 
              const Text('NOW YOU\'RE SIGNED IN',style: TextStyle(fontSize: 20),),
              
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => const ProfilePage()));
              //     },
              //     child: const Text('Goto profile')),
              // ElevatedButton(
              //     onPressed: () async{
              //       print('old password is ${await getData('jwt')}');
              //       refreshJwtToken();
              //        print('new password is ${await getData('jwt')}');
        
              //     },
              //     child: const Text('Refersh token')),
            
          
        ),
      );
  }
}