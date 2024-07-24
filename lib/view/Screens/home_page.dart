import 'package:chat/services/services.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/profile_page.dart';
import 'package:chat/view/Screens/settings_page.dart';
import 'package:chat/view/Widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
    String? firstName , lastName, email;
   List<Widget> pages=[];
  @override
  void initState() {
    super.initState();
    _getUserFullName();
    pages = [
      Home(),
      ProfilePage(
        firstName: firstName,
        lastName: lastName,
        email: email,
      ),
      SettingsPage(),
    ];
  }

  Future<void> _getUserFullName() async {
    firstName = await getData('firstName');
    lastName = await getData('lastName') ?? '';
    email = await getData('email') ?? '';
    
    // Initialize pages after data is fetched
    

    // Update the state to reflect changes
    setState(() {
      //isLoading = false;
    });
  }
  void navigateScreens(int index) {
    setState(() {
      currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavBar(
        onTabChange: (index) => navigateScreens(index),
      ),
      body: ProfilePage(firstName: firstName, lastName: lastName, email: email),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'NOW YOU\'RE SIGNED IN',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
