import 'package:chat_app_with_firebase/pages/group_info.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_with_firebase/pages/chat_page.dart';

class GroupTitlePage extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTitlePage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});
  @override
  State<GroupTitlePage> createState() => GroupTitlePageState();
}

class GroupTitlePageState extends State<GroupTitlePage> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
         nextScreen(context,  ChatPage(
         groupId:widget.groupId,
         groupName:widget.groupName,
         userName:widget.userName

         ));
      },
      child: 
    Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xffee7b64),
            child: Text(widget.groupId.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(.9),
                  fontWeight: FontWeight.bold,
                )),
          ),
          title: Text(widget.groupName,
            style:const TextStyle(
              fontWeight: FontWeight.bold,
            )
          ),
           subtitle: Text("Join the conversation as ${widget.userName}",
             style:  const TextStyle(
               fontSize: 13,
               color:Colors.white,
             ),
           ),
        )),
    );
    
    
  }
}
