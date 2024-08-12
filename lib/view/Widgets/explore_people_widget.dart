import 'package:chat/models/BLoCs/cubit/friend_request_cubit.dart';
import 'package:chat/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/constants.dart';

class ExplorePeopleWidget extends StatelessWidget {
  final String userName;
  final int id;
  String? profilePic;

  ExplorePeopleWidget(
      {super.key, required this.userName, required this.id, this.profilePic});

  void handleAddFriend(BuildContext context) async {
    bool result = await addFriend(id);
    if (result) {
      BlocProvider.of<FriendRequestCubit>(context).addFriend(id);
    }
  }

  void handleCancelFriend(BuildContext context) async {
    bool result = await cancelFriend(id);
    if (result) {
      BlocProvider.of<FriendRequestCubit>(context).cancelFriend(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(90, 122, 121, 121),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff54B22E),
                ),
                height: MediaQuery.of(context).size.width / 3,
                width: MediaQuery.of(context).size.width / 3,
                child: Image(
                  fit: BoxFit.cover,
                  image: profilePic != null
                      ? NetworkImage('https://chat-app.runasp.net/$profilePic')
                      : const AssetImage(kAvatar),
                )),
            Text(
              userName,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            BlocBuilder<FriendRequestCubit, Map<int, bool>>(
              builder: (context, pendingRequests) {
                final isPending = pendingRequests[id] ?? false;

                return GestureDetector(
                  onTap: isPending
                      ? () => handleCancelFriend(context)
                      : () => handleAddFriend(context),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: isPending ? Colors.grey : mainColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        isPending ? 'Pending' : 'Add Friend',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<FriendRequestCubit, Map<int, bool>>(
              builder: (context, pendingRequests) {
                final isPending = pendingRequests[id] ?? false;
                return isPending
                    ? GestureDetector(
                        onTap: () => handleCancelFriend(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(); // Return an empty container if not pending
              },
            ),
          ],
        ),
      ),
    );
  }
}
