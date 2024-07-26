import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/profile_page.dart';
import 'package:chat/view/Screens/requests_page.dart';
import 'package:chat/view/Screens/settings_page.dart';
import 'package:chat/view/Widgets/active_people_widget.dart';
import 'package:chat/view/Widgets/chatat_widget.dart';
import 'package:chat/view/Widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  String? firstName, lastName, email;
  List<Widget> pages = [];
  @override
  void initState() {
    super.initState();
    _getUserFullName();
    pages = [
      const Home(),
      ProfilePage(
        firstName: firstName,
        lastName: lastName,
        email: email,
      ),
      const RequestsPage(),
    ];
  }

  Future<void> _getUserFullName() async {
    firstName = await getData('firstName');
    lastName = await getData('lastName');
    email = await getData('email');

    setState(() {});
  }

  void navigateScreens(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: CustomNavBar(
        onTabChange: (index) => navigateScreens(index),
      ),
      body: pages[currentIndex],
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SearchBar(
            hintText: 'Search for Friends',
            leading: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search_rounded),
            ),
          ),
        ),
        const SizedBox(height: 16),
        //Active People
        Container(
          height: 100,
          child: Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
            children: [
              for (int i=0;i<10;i++)
                const ActivePeopleWidget()
            ],
          )),
        ),
Padding(
  padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(textAlign: TextAlign.start,'Your Chats',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
    ],
  ),
),
        Expanded(child: ListView(

children: [
  for (int i=0;i<10;i++)
  const ChatatWidget()
],        ))
      ],
    ));
  }
}
