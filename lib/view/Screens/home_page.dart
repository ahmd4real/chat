import 'package:chat/constants.dart';
import 'package:chat/models/BLoCs/cubit/friend_request_cubit.dart';
import 'package:chat/models/chat_model.dart';
import 'package:chat/services/services.dart';
import 'package:chat/services/signalR.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/explore_page.dart';
import 'package:chat/view/Screens/freindsRequests.dart';
import 'package:chat/view/Screens/inside_chat.dart';
import 'package:chat/view/Screens/profile_page.dart';
import 'package:chat/view/Widgets/chatat_widget.dart';
import 'package:chat/view/Widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  String firstName = '', lastName = '', email = '';
  String? profilePic, bio;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    _getUserFullName();
  }

  Future<void> _getUserFullName() async {
    firstName = await getData('firstName') ?? '';
    lastName = await getData('lastName') ?? '';
    email = await getData('email') ?? '';
    profilePic = await getData('profilePic');
    bio = await getData('bio');

    setState(() {
      pages = [
        const Home(),
        const ExplorePage(),
        const FriendsRequests(),
        ProfilePage(
          firstName: firstName,
          lastName: lastName,
          email: email,
          profilePic: profilePic,
          bio: bio,
        ),
      ];
    });
  }

  void navigateScreens(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FriendRequestCubit()..loadFriendRequestStates(),
        child: Scaffold(
          //appBar: AppBar(),
          bottomNavigationBar: CustomNavBar(
            onTabChange: (index) => navigateScreens(index),
          ),
          body: pages.isNotEmpty
              ? pages[currentIndex]
              : Center(
                  child: CircularProgressIndicator(
                  color: mainColor,
                )),
        ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Chat>> futureChats;
  late List<Chat> allChats;
  List<Chat> filteredChats = [];
  final TextEditingController _searchController = TextEditingController();
   late SignalRService signalRService;

  @override
  void initState() {
    super.initState();
    futureChats = fetchChats(kToken);
    futureChats.then((chats) {
      setState(() {
        allChats = chats;
        filteredChats = chats;
      });
    });

    _searchController.addListener(_filterChats);

    signalRService = SignalRService();
    signalRService.setupSignalR(kToken);
  }

  void _filterChats() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredChats = allChats.where((chat) {
        final user = chat.users[0];
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  void _deleteChat(Chat chat) async {
    await signalRService.deleteChat(chat.id);
    setState(() {
      allChats.remove(chat);
      filteredChats.remove(chat);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    signalRService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search for Friends',
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.search_rounded),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Chat>>(
              future: futureChats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: mainColor,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No chats available'));
                } else {
                  return ListView.builder(
                    itemCount: filteredChats.length,
                    itemBuilder: (context, index) {
                      final chat = filteredChats[index];

                      // Check if the users list is not empty before accessing the first element
                      if (chat.users.isNotEmpty) {
                        final user = chat.users[0];
                        final fullName = '${user.firstName} ${user.lastName}';
                        return ChatatWidget(
                          onLongpress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Chat'),
                                  content: const Text(
                                      'Are you sure you want to delete this chat?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                      _deleteChat(chat);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          userName: fullName,
                          onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                            final currentUserId = prefs.getInt('userId');
                           // await signalRService.setupSignalR(kToken);
                            print('Current user ID: $currentUserId');

                            signalRService.dispose();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InsideChat(
                                  chatId: chat.id,
                                  picUrl: user.profilePicture,
                                  fullName: fullName,
                                  //signalRService: signalRService,
                                   currentUserId: currentUserId!,
                                ),
                              ),
                            );
                          },
                          picUrl: user.profilePicture,
                        );
                      } else {
                        // Handle the case where the users list is empty
                        return const SizedBox
                            .shrink(); // Return an empty widget or handle accordingly
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
