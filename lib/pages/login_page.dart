import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_with_firebase/pages/register_page.dart';
import 'package:chat_app_with_firebase/pages/home_page.dart';
import 'package:chat_app_with_firebase/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app_with_firebase/helper/helper_function.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffee7b64),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 90.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Connectez-vous maintenant pour voir de quoi ils parlent.",
                                style: TextStyle(
                                  color: Colors.white10.withOpacity(.9),
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Image.asset("assets/login2.jpg"),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Email",
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Color(0xffee7b64),
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                                // check the validation

                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Please enter an email address.";
                                  }

                                  // Use the built-in email pattern to validate the email address.
                                  if (!RegExp(
                                          r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,}$')
                                      .hasMatch(val)) {
                                    return "Please enter a valid email address.";
                                  }

                                  return null; // Return null if the validation passes (no error).
                                },
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Please enter a password.";
                                  }

                                  if (val.length < 6) {
                                    return "Password must be at least 6 characters?";
                                  }
                                   return null;
                                },
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Password",
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Color(0xffee7b64),
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                              const SizedBox(height: 10.0),
                              TextButton(
                                onPressed: () {
                                  login();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(0xffee7b64),
                                  ),
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      "Se connecter",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.9),
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Text.rich(TextSpan(
                                text: "Vous n'avez pas de compte?",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.9),
                                  fontSize: 20.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Inscrivez-vous ici",
                                      style: const TextStyle(
                                        color: Color(0xffee7b64),
                                        fontSize: 20.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(
                                              context, const RegisterPage());
                                        })
                                ],
                              ))
                            ]))),
              ));
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .logInWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          // saving data to our shared preferences

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(
            snapshot.docs[0]["fullName"],
          );

          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Colors.green.withOpacity(.9), value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
