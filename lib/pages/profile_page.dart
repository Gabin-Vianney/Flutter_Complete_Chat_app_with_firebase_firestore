import 'package:flutter/material.dart';
import 'package:chat_app_with_firebase/service/auth_service.dart';
import 'package:chat_app_with_firebase/helper/helper_function.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:chat_app_with_firebase/pages/home_page.dart';
import 'package:chat_app_with_firebase/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  const ProfilePage({super.key, required this.email, required this.userName});
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        //email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      // userName = val!;
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
          "Profile",
          style: TextStyle(
            color: Colors.white.withOpacity(.9),
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            const  Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 50.0),
            Text(widget.userName,

                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold,color:Colors.black)),
            const SizedBox(height: 30.0),
            const Divider(
              height: 2.0,
            ),
            ListTile(
              onTap: () {
                nextScreen(context, const HomePage());
              },
              selectedColor: const Color(0xffee7b64),
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
            ListTile(
              onTap: () async {},
              selected: true,
              selectedColor: const Color(0xffee7b64),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.group),
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
              leading: const Icon(Icons.exit_to_app,color:Colors.black),
              title: const Text(
                "Se déconnecter",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.white,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nom complet",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                )
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
