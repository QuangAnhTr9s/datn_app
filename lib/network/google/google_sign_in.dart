import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogle{
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleUser;
  GoogleSignInAccount get googleUser => _googleUser!;
  Future<User?> signInWithGoogle() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return null;
    _googleUser = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //mỗi lần đăng nhập, trả về UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    //chuyển UserCredential về dạng User
    User? user = userCredential.user;
    return user;
    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }
   //Sign out
  Future<void> signOut() async {
    googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}