
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hazara_room/Services/Firestore/firestore_services.dart';
import 'package:hazara_room/helper/helper_function.dart';

class AuthService {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;



  // login
  Future loginUserWithEmailAndPassword( String email, String password) async{
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user!;

      if(user !=null ) {
        return true;
      }

    }on FirebaseAuthException catch(e) {
      return e.message;
    }
  }



  // register
  Future registerUserWithEmailAndPassword(
    String fullname, String email, String password,) async{
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)).user!;

      if(user !=null) {
        await FirestoreService(userId: user.uid ).saveUserData(fullname, email);
        return true;
      }

    }on FirebaseAuthException catch(e) {
      return e.message;
    }
  }


  // logout
  Future logOutUser() async{
    try {
      await HelperFunction.saveUserLoginStatus(false);
      await HelperFunction.saveUserEmailSP("");
      await HelperFunction.saveUserNameSP("");

      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

}