import 'package:chat/core/utils/constants.dart';
import 'package:chat/view/Screens/profile_page.dart';
import 'package:flutter/material.dart';

class RequestWidget extends StatelessWidget {
  RequestWidget(
      {super.key,
      required this.fullName,
      required this.bio,
      this.onAccept,
      this.onCancel,
      this.profilePicture});
  final String fullName;
  final String bio;
  String? profilePicture;
  void Function()? onAccept;
  void Function()? onCancel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: profilePicture != null
            ? NetworkImage('https://chat-app.runasp.net/${profilePicture!}')
            : const AssetImage(kAvatar) as ImageProvider,
        radius: 30,
      ),
      title: Text(fullName),
      subtitle: Text(bio),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: onAccept,
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 32,
                )),
            IconButton(
                onPressed: onCancel,
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 32,
                )),
          ],
        ),
      ),
    );
  }
}
