import 'package:flutter/material.dart';
import 'package:chat_app_with_firebase/service/auth_service.dart';
import 'package:chat_app_with_firebase/helper/helper_function.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:chat_app_with_firebase/pages/search_page.dart';
import 'package:chat_app_with_firebase/pages/login_page.dart';
import 'package:chat_app_with_firebase/pages/profile_page.dart';
import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_with_firebase/widgets/group_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool isLoading = false;
  String groupName = "";
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      userName = val!;
    });

    // getting the list of snapshot in our stream

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  // string  manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
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
          " Groupes",
          style: TextStyle(
            color: Colors.white.withOpacity(.9),
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, const SearchPage());
            },
            icon: const Icon(Icons.search),
            color: Colors.white.withOpacity(.9),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 60,
              color: Colors.black,
            ),
            const SizedBox(height: 50.0),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 30.0),
            const Divider(
              height: 2.0,
            ),
            ListTile(
              onTap: () {},
              selectedColor: const Color(0xffee7b64),
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.group, color: Colors.black),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
            ListTile(
              onTap: () async {
                authService.signOut().whenComplete(
                      () => nextScreenReplace(context,
                          ProfilePage(email: email, userName: userName)),
                    );
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.group, color: Colors.black),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          "Se déconnecter",
                        ),
                        content: const Text(
                          "Are you sure you want to logout?",
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
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.exit_to_app, color: Colors.black),
              title: const Text(
                "Se déconnecter",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: groupList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(
            context,
          );
        },
        elevation: 0,
        backgroundColor: const Color(0xffee7b64),
        child: Icon(
          Icons.add,
          color: Colors.white.withOpacity(.9),
          size: 30,
        ),
      ),
    );
  }

  Widget groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data["groups"].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data["groups"].length - index - 1;

                  return GroupTitlePage(
                      groupId: getId(snapshot.data["groups"][reverseIndex]),
                      groupName: getName(snapshot.data["groups"][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffee7b64),
            ),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[100],
              size: 75,
            ),
          ),
          const Text(
              "Vous n'avez rejoint aucun groupe, appuyez sur l'icône d'ajout \n pour créer un groupe ou  effectuez également une recherche à partir \n du bouton de recherche en haut.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Create a group",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black.withOpacity(.9))),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Color(0xffee7b64),
                      ))
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xffee7b64),
                                  width: 2.0,
                                )),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xffee7b64),
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xffee7b64),
                                width: 2.0,
                              ),
                            )),
                      )
              ]),
              actions: [
                Row(children: [
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xffee7b64),
                      ),
                      height: 30.0,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (groupName != "") {
                        setState(() {
                          isLoading = true;
                        });
                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .createGroup(
                                userName,
                                FirebaseAuth.instance.currentUser!.uid,
                                groupName)
                            .whenComplete(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackBar(context, Colors.green.withOpacity(.9),
                            "Group created successfully");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xffee7b64),
                      ),
                      height: 30.0,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Center(
                        child: Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            );
          },
        );
      },
    );
  }
}
