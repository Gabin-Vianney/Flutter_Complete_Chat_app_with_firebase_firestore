import 'package:flutter/material.dart';
import 'package:chat_app_with_firebase/service/auth_service.dart';
import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app_with_firebase/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:chat_app_with_firebase/pages/chat_page.dart';

/*import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:chat_app_with_firebase/pages/login_page.dart';*/
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  AuthService authService = AuthService();
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String? userName = "";

  User? user;

  bool isJoined = false;
  @override
  void initState() {
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xffee7b64),
          title: Text(
            "Search",
            style: TextStyle(
              color: Colors.white.withOpacity(.9),
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: const Color(0xffee7b64),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search groups...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ))),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xffee7b64).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.white.withOpacity(.9),
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffee7b64),
                  ),
                )
              : groupList(),
        ]));
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchGroupByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTitle(
                  userName,
                  searchSnapshot!.docs[index]["groupId"],
                  searchSnapshot!.docs[index]["groupName"],
                  searchSnapshot!.docs[index]["admin"]);
            },
          )
        : Container();
  }

  joinedOrNot(
      String? userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName!)
        .then((value) {
      isJoined = value;
    });
  }

  Widget groupTitle(
      String? userName, String groupId, String groupName, String admin) {
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: const Color(0xffee7b64),
          child: Text(groupName.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white)),
        ),
        title: Text(groupName,
            style: TextStyle(color: Colors.white.withOpacity(.9))),
        subtitle: Text("Admin:${getName(admin)}",
            style: TextStyle(color: Colors.white.withOpacity(.2))),
        trailing: InkWell(
          onTap: () async {
            await DatabaseService(uid: user!.uid)
                .toggleGroupJoin(groupId, userName!, groupName);
            if (isJoined) {
              setState(() {
                isJoined = !isJoined;
              });

              showSnackBar(context, Colors.green, "Successfully joined group");
      
              Future.delayed(const Duration(seconds: 2));
              nextScreen(
                  context,
                  ChatPage(
                      groupId: groupId,
                      groupName: groupName,
                      userName: userName));
            } else {
              setState(() {
                isJoined = !isJoined;
              });
              showSnackBar(context, Colors.green, "Left the group $groupName");
            }
          },
          child: isJoined
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Joined",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.9),
                        fontSize: 13,
                      )))
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffee7b64),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Join now ",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.9),
                        fontSize: 13,
                      ))),
        ));
  }
}
