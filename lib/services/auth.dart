import 'package:fellas/helper/helper_function.dart';
import 'package:fellas/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUser(String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if(user!=null){
        await Database(uid: user.uid).updateUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

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
