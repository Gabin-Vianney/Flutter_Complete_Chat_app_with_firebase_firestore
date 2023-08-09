import 'package:chat_app_with_firebase/pages/home_page.dart';
import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupName;
  final String groupId;
  final String adminName;
  const GroupInfoPage(
      {super.key,
      required this.adminName,
      required this.groupName,
      required this.groupId});
  @override
  State<GroupInfoPage> createState() => GroupInfoPageState();
}

class GroupInfoPageState extends State<GroupInfoPage> {
  Stream? members;
  @override
  void initState() {
    super.initState();
    getMembers();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      members = val;
    });
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xffee7b64),
        title: Text(
          "Group Info",
          style: TextStyle(
            color: Colors.white.withOpacity(.9),
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text(
                        "Exit group",
                      ),
                      content: const Text(
                        "Are you sure you want to exit the group?",
                        style: TextStyle(
                          color: Color(0xffee7b64),
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                          ),
                          color: const Color(0xffee7b64),
                        ),
                        IconButton(
                          onPressed: () async {
                            DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .toggleGroupJoin(widget.groupId,
                                    getName(widget.adminName), widget.groupName)
                                .whenComplete(() {
                              nextScreenReplace(context, const HomePage());
                            });
                          },
                          icon: const Icon(
                            Icons.done,
                          ),
                          color: Colors.green,
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.exit_to_app),
            color: Colors.white.withOpacity(.9),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xffee7b64).withOpacity(.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: const Color(0xffee7b64),
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          color: Colors.white.withOpacity(.9),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Groupe: ${widget.groupName}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Admin : ${getName(widget.adminName)}",
                        style: const TextStyle(
                          color: Colors.white10,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data["members"].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data["members"].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return (Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: const Color(0xffee7b64),
                          child: Text(
                            getName(snapshot.data["members"])
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(.9),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          getName(
                            snapshot.data["members"][index],
                          ),
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                          ),
                        ),
                        subtitle: Text(getId(snapshot.data["members"][index])),
                      ),
                    ));
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    "NO MEMBER",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text(
                  "NO MEMBER",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xffee7b64),
              ),
            );
          }
        });
  }
}
