import 'package:chat/services/services.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
static String id = 'HomePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Home Page'),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()));
                  },
                  child: const Text('Goto profile')),
              ElevatedButton(
                  onPressed: () async{
                    print('old password is ${await getData('jwt')}');
                    refreshJwtToken();
                     print('new password is ${await getData('jwt')}');
        
                  },
                  child: const Text('Refersh token')),
            ],
          ),
        ),
      ),
    );
  }
}
