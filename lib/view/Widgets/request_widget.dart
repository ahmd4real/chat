import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class RequestWidget extends StatelessWidget {
   RequestWidget({super.key,required this.fullName,required this.bio,this.onAccept,this.onCancel});
   final String fullName ;
   final String bio ;
   void Function()? onAccept;
   void Function()? onCancel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage(kAvatar),
        radius: 30,
      ),
      title:  Text(fullName),
      subtitle:  Text(bio),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: onAccept, icon: const Icon(Icons.check_circle_outline,color: Colors.green,size: 32,)),
            IconButton(onPressed: onCancel, icon: const Icon(Icons.cancel_outlined,color: Colors.red,size: 32,)),

          ],
        ),
      ),

    );
  }
}