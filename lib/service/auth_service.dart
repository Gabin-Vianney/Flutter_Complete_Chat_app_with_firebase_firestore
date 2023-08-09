import 'package:chat_app_with_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_with_firebase/helper/helper_function.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // login function
  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        // call our database to update user data
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        // Password is incorrect.
        return 'Le mot de passe est incorrect.';
      } else {
        // Other login errors.
        return e.message;
      }
    }
    return null; // Return null if no user or error.
  }

// register function
  Future<dynamic> registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        // call our database to update user data
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Cet utilisateur existe déjà.';
      } else {
        return e.message;
      }
    }
    return null; // Return null if no user or error.
  }

  // sign out function
  Future<dynamic> signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
