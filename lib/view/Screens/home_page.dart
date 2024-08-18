import 'package:chat/constants.dart';
import 'package:chat/models/BLoCs/cubit/friend_request_cubit.dart';
import 'package:chat/models/chat_model.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/services/services.dart';
import 'package:chat/services/signalR.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/explore_page.dart';
import 'package:chat/view/Screens/friendsRequests.dart';
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
          backgroundColor: background,
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

late List<Chat> allChats;
List<Chat> filteredChats = [];
late Chat chatToDelete;
List<Chat> lastMsgs = [];
int? currentUserId;
late List<Map<String, String>> mp;

class _HomeState extends State<Home> {
  late Future<List<Chat>> futureChats;
  Map<String, String> userOnlineStatus = {};

  final TextEditingController _searchController = TextEditingController();
  SignalRService signalRService = SignalRService();

  @override
  void initState() {
    super.initState();
    getCurrentUserId();

    futureChats = fetchChats(kToken);
    futureChats.then((chats) {
      setState(() {
        allChats = chats;
        filteredChats = chats;
      });
    });

    _searchController.addListener(_filterChats);

    signalRService.setupSignalR(kToken, onDeleteChat: () {
      print('hello from onDeleteChat->initState->home_page.dart');
      setState(() {
        allChats.remove(chatToDelete);
        filteredChats.remove(chatToDelete);
      });
    }, onUserOnlineStatus: (isOnline) {
      print('hello from onUserOnlineStatus->initState->home_page.dart');
      if (isOnline) {
        print('user is online');
      } else {
        print('user is offline');
      }
    });
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

  getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getInt('userId');
  }

  Future<void> fetchChatsId(String token) async {
    lastMsgs = await fetchChats(token);
  }

  Future<void> isOnline(String chatId) async {
    await signalRService.isOnline(chatId);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBar(
                hintStyle:
                    WidgetStatePropertyAll(TextStyle(color: searchContent)),
                backgroundColor: WidgetStatePropertyAll(
                    searchBack), //MaterialAccentColor(primary, swatch),
                controller: _searchController,
                hintText: 'Search for Friends',
                leading: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.search_sharp,
                    color: searchContent,
                    size: 32,
                  ),
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
                        isOnline(chat.id);

                        if (chat.users.isNotEmpty) {
                          final user = chat.users[0];
                          final fullName = '${user.firstName} ${user.lastName}';
                          final status = userOnlineStatus[chat.id] ??
                              'Offline'; // Get the status
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ChatatWidget(
                              //isOnline: status,
                              onLongpress: () {
                                chatToDelete = chat;
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
                              timeAgo: chat.lastMessageDate,
                              userName: fullName,
                              lastMsg: chat.lastMessage, //lastMsgs[index] ,
                              whoSentMsg: '',
                              //numberOfUnread: 7,
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final currentUserId = prefs.getInt('userId');
                                signalRService.dispose();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InsideChat(
                                      chatId: chat.id,
                                      picUrl: user.profilePicture,
                                      fullName: fullName,
                                      currentUserId: currentUserId!,
                                    ),
                                  ),
                                );
                              },
                              picUrl: user.profilePicture,
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}






                    
                    //####################################################################
                   
                    //#######################################################################
                 
                 