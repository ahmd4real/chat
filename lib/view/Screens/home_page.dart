import 'package:chat/services/services.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Home Page'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
                child: Text('Goto profile')),
            ElevatedButton(
                onPressed: () async{
                  print('old password is ${await getData('jwt')}');
                  refreshJwtToken();
                   print('new password is ${await getData('jwt')}');

                },
                child: Text('Refersh token')),
          ],
        ),
      ),
    );
  }
}
