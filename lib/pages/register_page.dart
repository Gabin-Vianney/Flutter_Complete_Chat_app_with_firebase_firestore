import 'package:chat_app_with_firebase/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_with_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:chat_app_with_firebase/pages/login_page.dart';
import 'package:chat_app_with_firebase/service/auth_service.dart';
import 'package:chat_app_with_firebase/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared preferences state

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, const Color(0xffee7b64).withOpacity(.9), value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 90.0),
          child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                     Text(
                      "Créez votre compte maintenant pour discuter et explorer.",
                      style: TextStyle(
                        color: Colors.white10.withOpacity(.9),
                        fontSize: 40.0,
                      ),
                    ),
                     const SizedBox(
                      height: 25,
                    ),
                    Image.asset("assets/login1.jpg"),
                  
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Nom complet",
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xffee7b64),
                        ),
                      ),

                      onChanged: (val) {
                        setState(() {
                          fullName = val;
                        });
                      },

                      // check the validation

                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter your name.";
                        }

                        return null; // Return null if the validation passes (no error).
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: false,
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
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
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
                    ),
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        register();
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
                            "S'inscrire",
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
                      text: "Vous avez dejà un compte?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.9),
                        fontSize: 20.0,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Connectez-vous ici",
                            style: const TextStyle(
                              color: Color(0xffee7b64),
                              fontSize: 20.0,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextScreenReplace(context, const LoginPage());
                              })
                      ],
                    ))
                  ]))),
    ));
  }
}
