import 'package:chat/models/BLoCs/cubit/friend_request_cubit.dart';
import 'package:chat/services/services.dart';
import 'package:chat/view/Screens/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/core/utils/constants.dart';




class ExplorePeopleWidget extends StatelessWidget {
  final String userName;
  final int id;
  String? profilePic;
  String? bio;
  //String userId;

  ExplorePeopleWidget(
      {super.key, this.bio,required this.userName, required this.id, this.profilePic});

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
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfilePage(
                    bio:bio,
                        userName: userName,
                        profilePic: profilePic,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: searchBack,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: profilePic != null ? noColor : kGreen,
                ),
                height: MediaQuery.of(context).size.width / 2.5,
                width: MediaQuery.of(context).size.width / 2.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: profilePic != null
                      ? Image(
                          image: NetworkImage(
                              'https://chat-app.runasp.net/$profilePic'),
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person_rounded,
                          color: kWhite,
                          size: MediaQuery.of(context).size.width / 2.5,
                        ),
                ),
              ),
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

                  return InkWell(
                    onTap: isPending
                        ? () => handleCancelFriend(context)
                        : () => handleAddFriend(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: isPending ? Colors.grey : kGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              isPending
                                  ? Icons.cancel
                                  : Icons.person_add_alt_1_outlined,
                              color: kWhite,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              isPending ? 'Pending' : 'Add Friend',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
