import 'package:fellas/helper/helper_function.dart';
import 'package:fellas/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Login function

  Future loginUser(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if(user!=null){
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Register function

  Future registerUser(String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if(user!=null){
        await Database(uid: user.uid).saveUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SignOut function

  Future signOut()async{
    try{
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmail("");
      await HelperFunctions.saveUserName("");
      await firebaseAuth.signOut();
    }catch(e){
      return null;
    }
  }
}
