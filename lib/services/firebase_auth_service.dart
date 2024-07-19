// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> login(String email, String password) async {
//     UserCredential result = await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     return result.user;
//   }

//   Future<User?> register(String email, String password) async {
//     UserCredential result = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     return result.user;
//   }

//   Future<void> logout() async {
//     await _auth.signOut();
//   }

//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   Stream<User?> authStateChanges() {
//     return _auth.authStateChanges();
//   }
// }





import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /* login - foydalanuvchini tizimga kiritish
   Kiritilgan email va parol orqali foydalanuvchini tizimga kiritadi  */
  Future<User?> login(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  /* register - yangi foydalanuvchini ro'yxatdan o'tkazish
   Kiritilgan email va parol bilan yangi foydalanuvchini ro'yxatdan o'tkazadi  */
  Future<User?> register(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  /* logout - foydalanuvchini tizimdan chiqarish
   Foydalanuvchini tizimdan chiqaradi  */

  Future<void> logout() async {
    await _auth.signOut();
  }

  /* getCurrentUser - joriy foydalanuvchini olish
   Joriy tizimga kirgan foydalanuvchini qaytaradi */


  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /* authStateChanges - autentifikatsiya holatining o'zgarishlarini kuzatish
   Autentifikatsiya holatining o'zgarishlarini stream orqali kuzatish imkonini beradi  */
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
