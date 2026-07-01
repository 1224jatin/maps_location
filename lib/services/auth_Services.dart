import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser (String email , String password) async{
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = userCredential.user;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).set({
          'email': email,
          'password': password,
        });
      }

    } on FirebaseAuthException catch (e){
      print(e);
    }

}
Future<User?> login(String email , String password) async{
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = userCredential.user;
      return user;

      } on FirebaseAuthException catch (e){
      print(e);
    }
    return null;
}

}
