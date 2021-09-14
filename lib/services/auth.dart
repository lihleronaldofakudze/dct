import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RegisteredUser? userFromFirebase(User? user) {
    return user != null ? RegisteredUser(number: user.phoneNumber) : null;
  }

  Stream<RegisteredUser?> get user {
    return _auth.authStateChanges().map(userFromFirebase);
  }

  //Sign Out
  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      print(error);
    }
  }
}
