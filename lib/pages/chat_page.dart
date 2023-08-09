import 'package:chat_app_with_firebase/widgets/message_title.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_with_firebase/pages/group_info.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app_with_firebase/service/database_service.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});
  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";

  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    DatabaseService().groupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xffee7b64),
        title: Text(
          widget.groupName,
          style: TextStyle(
            color: Colors.white.withOpacity(.9),
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                  context,
                  GroupInfoPage(
                      groupId: widget.groupId,
                      adminName: widget.userName,
                      groupName: widget.groupName));
            },
            icon: const Icon(Icons.info),
            color: Colors.white.withOpacity(.9),
          ),
        ],
      ),
      body: Stack(children: [
        // chat message here

        chatMessage(),

        Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(40),
                  border:
                      Border.all(width: 2, color: Colors.white.withOpacity(.9)),
                ),
                child: Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Envoyer un message",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xffee7b64),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ])))
      ]),
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      messageController.clear();
    }
  }

  Widget chatMessage() {
    return StreamBuilder(
      stream: chats, // This stream should provide the chat messages
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xffee7b64),
          ));
          // Show a loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  )));
        } else if (!snapshot.hasData) {
          return const Center(
              child: Text('No messages available.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  )));
          // Display a message if there are no messages
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTitlePage(
                message: snapshot.data.docs[index]["message"],
                sender: snapshot.data.docs[index]["sender"],
                sendByMe:
                    widget.userName == snapshot.data.docs[index]["sender"],
              );
            },
          );
        }
      },
    );
  }
}
