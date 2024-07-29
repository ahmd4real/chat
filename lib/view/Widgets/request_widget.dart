import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class RequestWidget extends StatelessWidget {
  const RequestWidget({super.key,required this.fullName,required this.bio});
   final String fullName ;
   final String bio ;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage(kAvatar),
        radius: 30,
      ),
      title:  Text(fullName),
      subtitle:  Text(bio),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: (){
              print('Accept');
            }, icon: Icon(Icons.check_circle_outline,color: Colors.green,)),
            IconButton(onPressed: (){
        print('cancel');
      }, icon: Icon(Icons.cancel_outlined,color: Colors.red,)),

          ],
        ),
      ),

    );
  }
}